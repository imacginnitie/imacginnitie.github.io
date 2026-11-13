# Goodreads "currently reading" feature, gratefully adapted from Andy Liu's site:
# https://github.com/andyjliu/andyjliu.github.io  (thank u Andy)

require 'jekyll'
require 'json'

module GoodreadsReading
  class GoodreadsReadingGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      # Check if goodreads_reading is enabled
      return unless site.config['goodreads_reading'] && site.config['goodreads_reading']['enabled']

      user_id = site.config['goodreads_reading']['user_id']
      return unless user_id

      current_book = nil
      last_read_book = nil
      previous_books = []

      # Try to read from cached JSON file first
      data_file = File.join(site.source, '_data', 'goodreads-reading.json')
      if File.exist?(data_file)
        begin
          data = JSON.parse(File.read(data_file))
          current_book = data['current_book']
          last_read_book = data['last_read_book']
          previous_books = data['previous_books'] || []
          Jekyll.logger.info 'Goodreads Reading:', 'Loaded from cache file'
        rescue => e
          Jekyll.logger.warn 'Goodreads Reading:', "Failed to read cache file: #{e.message}"
        end
      end

      # The data is produced by the updater workflow in
      # .github/scripts/update-goodreads-reading.rb and committed to the cache
      # file above. There used to be a live RSS fallback here, but Goodreads
      # removed its RSS feeds in Oct 2026, so the build relies on the cache only.
      if current_book.nil? && last_read_book.nil?
        Jekyll.logger.warn 'Goodreads Reading:', 'No cached reading data; run the update-goodreads-reading workflow.'
      end

      site.data['goodreads_reading'] = {
        'current_book' => current_book,
        'last_read_book' => last_read_book,
        'previous_books' => previous_books
      }
    end
  end
end
