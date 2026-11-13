#!/usr/bin/env ruby

# Goodreads removed its public RSS feeds (review/list_rss) in late Oct 2026, so
# we now read two public, no-login pages instead:
#   - the profile page, for the "currently reading" box
#   - the custom shelf widget, for the read shelf (newest first, with ratings)
#
# The two are fetched independently. If one fails, its part of the cached data
# is kept as-is and the other part is still updated; the script then exits
# non-zero so the workflow run shows up as failed (it still commits whatever
# did update).

require 'httparty'
require 'nokogiri'
require 'json'
require 'fileutils'

# Configuration
USER_ID = ENV['GOODREADS_USER_ID'] || '155965994'
DATA_DIR = '_data'
DATA_FILE = File.join(DATA_DIR, 'goodreads-reading.json')
# How many recently-read books to keep for the "Previously" hover. We store one
# extra so the hover can still show a few even when nothing is currently-reading
# (in which case the most recent read fills the sentence itself).
READ_SHELF_LIMIT = 4

HEADERS = { 'User-Agent' => 'Mozilla/5.0 (compatible; goodreads-reading-updater)' }.freeze

# Star-rating tooltips used by Goodreads' widget.
RATING_TITLES = {
  'did not like it' => 1,
  'it was ok' => 2,
  'liked it' => 3,
  'really liked it' => 4,
  'it was amazing' => 5
}.freeze

def clean_title(title)
  # Remove parenthetical phrases at the end of titles, e.g. "(Star Wars)".
  title.gsub(/\s*\([^)]+\)\s*$/, '').strip
end

def book_hash(title, author, book_id, fallback_url = '')
  title = clean_title(title.to_s)
  return nil if title.empty?

  book_id = book_id.to_s.strip
  book_id = nil if book_id.empty?
  {
    'title' => title,
    'author' => author.to_s.strip,
    'url' => book_id ? "https://www.goodreads.com/book/show/#{book_id}" : fallback_url.to_s.strip,
    'book_id' => book_id
  }
end

def get(url)
  response = HTTParty.get(url, timeout: 15, headers: HEADERS)
  raise "HTTP #{response.code} from #{url}" unless response.code == 200

  response.body.to_s
end

# First book in the profile's "Currently Reading" box, or nil if the shelf is
# genuinely empty. Raises if the page doesn't look like we expect, so a layout
# change isn't mistaken for "not reading anything".
def fetch_current_book
  doc = Nokogiri::HTML(get("https://www.goodreads.com/user/show/#{USER_ID}"))

  shelf_link = doc.css('a.userShowPageShelfListItem').find { |a| a['href'].to_s.include?('shelf=currently-reading') }
  raise 'currently-reading shelf link not found on profile page' unless shelf_link

  count = shelf_link.text[/\((\d+)\)/, 1]
  raise 'currently-reading shelf count not found on profile page' unless count
  return nil if count.to_i.zero?

  entry = doc.css('#currentlyReadingReviews .Updates').first
  title_link = entry&.at_css('a.bookTitle')
  raise "shelf has #{count} book(s) but none could be parsed from the profile page" unless title_link

  book_id = title_link['href'].to_s[%r{/book/show/(\d+)}, 1]
  author = entry.at_css('a.authorName')&.text
  book_hash(title_link.text, author, book_id) or raise 'currently-reading book has no title'
end

# Most recently read books (newest first) with your star rating (0 if unrated).
def fetch_read_books(limit)
  url = "https://www.goodreads.com/review/custom_widget/#{USER_ID}.read" \
        "?shelf=read&sort=date_read&order=d&num_books=#{limit}" \
        '&show_cover=1&show_title=1&show_author=1&show_rating=1&show_review=0&widget_id=site'
  js = get(url)

  # The response is JS that assigns the widget HTML to a single-quoted string.
  raw = js[/var widget_code = '(.*?)'\s*\n/m, 1]
  raise 'widget_code not found in widget response' unless raw

  html = raw.gsub('\\"', '"').gsub('\\/', '/').gsub("\\'", "'").gsub('\\n', "\n")
  doc = Nokogiri::HTML(html)

  books = doc.css('.gr_custom_each_container_site').map do |entry|
    title_link = entry.at_css('.gr_custom_title_site a')
    next unless title_link

    # The widget links to the review, but the cover image path ends in the book ID.
    cover = entry.at_css('.gr_custom_book_container_site img')&.[]('src').to_s
    book_id = cover[%r{/(\d+)\.[^/]*\.jpg}, 1]
    author = entry.at_css('.gr_custom_author_site a')&.text
    rating_title = entry.at_css('.gr_custom_rating_site .staticStars')&.[]('title').to_s.strip

    book = book_hash(title_link.text, author, book_id, title_link['href'].to_s.sub(/\?.*/, ''))
    book && book.merge('rating' => RATING_TITLES.fetch(rating_title, 0))
  end.compact.first(limit)

  # The read shelf is never empty, so no books means the widget changed.
  raise 'no books parsed from the read-shelf widget' if books.empty?

  books
end

existing = {}
if File.exist?(DATA_FILE)
  begin
    existing = JSON.parse(File.read(DATA_FILE))
  rescue => e
    STDERR.puts "Warning: Failed to parse existing data file: #{e.message}"
  end
end

failures = []

current_book = begin
  fetch_current_book
rescue => e
  failures << "currently-reading (kept cached value): #{e.message}"
  existing['current_book']
end

previous_books = begin
  fetch_read_books(READ_SHELF_LIMIT)
rescue => e
  failures << "read shelf (kept cached value): #{e.message}"
  existing['previous_books'] || []
end

# Most recent read, used as the sentence subject when nothing is currently-reading.
last_read_book = previous_books.first

if failures.size == 2
  # Nothing new to write; leave the file (and its last_updated) alone.
  failures.each { |msg| puts "::error title=Goodreads::#{msg}" }
  exit 1
end

new_data = {
  'current_book' => current_book,
  'last_read_book' => last_read_book,
  'previous_books' => previous_books,
  'last_updated' => Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
}

FileUtils.mkdir_p(DATA_DIR)
File.write(DATA_FILE, JSON.pretty_generate(new_data) + "\n")

puts 'Goodreads reading data updated'
puts "Current book: #{current_book ? current_book['title'] : 'None'}"
puts "Previous books: #{previous_books.map { |b| "#{b['title']} (#{b['rating']}★)" }.inspect}"

unless failures.empty?
  failures.each { |msg| puts "::error title=Goodreads::#{msg}" }
  exit 1
end
