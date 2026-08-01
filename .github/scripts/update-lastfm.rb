#!/usr/bin/env ruby

require 'httparty'
require 'json'
require 'yaml'
require 'fileutils'

USER = ENV['LASTFM_USER'] || 'isabel-mp3'
API_KEY = ENV['LASTFM_API_KEY']
DATA_DIR = '_data'
DATA_FILE = File.join(DATA_DIR, 'lastfm.yml')
TOP_LIMIT = 3
PROFILE_URL = "https://www.last.fm/user/#{USER}"

unless API_KEY && !API_KEY.strip.empty?
  STDERR.puts 'LASTFM_API_KEY is not set. Exiting.'
  exit 0
end

url = "http://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=#{USER}&period=7day&limit=#{TOP_LIMIT}&api_key=#{API_KEY}&format=json"

begin
  response = HTTParty.get(url, timeout: 15)
  body = response.parsed_response
rescue => e
  STDERR.puts "Warning: Last.fm request failed: #{e.message}"
  exit 0
end

raw = body.dig('topartists', 'artist')
artists = case raw
          when Array then raw
          when Hash then [raw]
          else []
          end

top = artists
      .map { |a| a.is_a?(Hash) ? a['name'] : nil }
      .compact
      .map(&:strip)
      .reject(&:empty?)
      .take(TOP_LIMIT)

if top.empty?
  puts 'No artist data returned or API error. Exiting without changes.'
  exit 0
end

first = artists[0]
artist_url = first.is_a?(Hash) ? first['url'] : nil

today = Time.now.utc.strftime('%Y-%m-%d')

out = {
  'artist' => top.first,
  'url' => artist_url,
  'profile' => PROFILE_URL,
  'updated' => today,
  'top_artists' => top
}

FileUtils.mkdir_p(DATA_DIR)
File.write(DATA_FILE, out.to_yaml)

puts "Updated top artists: #{top.inspect}"

exit 0
