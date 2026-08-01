#!/usr/bin/env ruby

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

def clean_title(title)
  # Remove parenthetical phrases at the end of titles, e.g. "(Star Wars)".
  title.gsub(/\s*\([^)]+\)\s*$/, '').strip
end

def book_url(book_id, fallback_link)
  if book_id && !book_id.to_s.strip.empty?
    "https://www.goodreads.com/book/show/#{book_id}"
  else
    fallback_link.to_s.strip
  end
end

def text_at(item, tag)
  node = item.xpath(tag).first
  node ? node.text.strip : ''
end

# Parse a single <item> from a Goodreads shelf RSS feed. Returns nil for items
# without a usable title. `rating` is 0 when unrated (you only rate on finishing).
def parse_item(item)
  title = clean_title(text_at(item, 'title'))
  return nil if title.empty?

  book_id = text_at(item, 'book_id')

  {
    'title' => title,
    'author' => text_at(item, 'author_name'),
    'url' => book_url(book_id, text_at(item, 'link')),
    'book_id' => (book_id.empty? ? nil : book_id),
    'rating' => text_at(item, 'user_rating').to_i
  }
end

def fetch_shelf(shelf, extra = '')
  url = "https://www.goodreads.com/review/list_rss/#{USER_ID}?shelf=#{shelf}#{extra}"
  xml = HTTParty.get(url, timeout: 10).body
  return [] if xml.nil? || xml.strip.empty?

  doc = Nokogiri::XML(xml) do |config|
    config.nonet.noblanks
  end
  doc.xpath('//item').map { |item| parse_item(item) }.compact
rescue => e
  STDERR.puts "Warning: Failed to fetch #{shelf} shelf: #{e.message}"
  []
end

# Currently reading (may be empty). Drop the rating: you rate on finishing, so a
# rating on an in-progress book is meaningless / misleading.
current_book = fetch_shelf('currently-reading').first
current_book = current_book.reject { |k, _| k == 'rating' } if current_book

# Recently read, newest first, with author + rating for the "Previously" hover.
previous_books = fetch_shelf('read', '&sort=date_read&order=d').first(READ_SHELF_LIMIT)

# Most recent read, used as the sentence subject when nothing is currently-reading.
last_read_book = previous_books.first

new_data = {
  'current_book' => current_book,
  'last_read_book' => last_read_book,
  'previous_books' => previous_books,
  'last_updated' => Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
}

existing_data = {}
if File.exist?(DATA_FILE)
  begin
    existing_data = JSON.parse(File.read(DATA_FILE))
  rescue => e
    STDERR.puts "Warning: Failed to parse existing data file: #{e.message}"
  end
end

data_changed = (new_data.to_json != existing_data.to_json)

FileUtils.mkdir_p(DATA_DIR)
File.write(DATA_FILE, JSON.pretty_generate(new_data))

puts 'Goodreads reading data updated'
puts "Current book: #{current_book ? current_book['title'] : 'None'}"
puts "Previous books: #{previous_books.map { |b| "#{b['title']} (#{b['rating']}★)" }.inspect}"
puts "Data changed: #{data_changed}"

exit 0
