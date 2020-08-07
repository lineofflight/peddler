#!/usr/bin/env ruby
# frozen_string_literal: true

require 'open3'
require 'net/http'
require 'logger'

logger = Logger.new($stdout)

search_command = 'grep -R @see ./lib'
output, = Open3.capture3(search_command)
matches = output.split("\n")

failed = false

threads = matches.map do |line|
  Thread.new do
    url = line.match(/http.*/)[0]
    response = Net::HTTP.get_response(URI(url))
    case response
    when Net::HTTPSuccess
      logger.info "✅ #{response.code} #{url}"
    when Net::HTTPFound
      logger.warn "👀 #{response.code} #{url}"
    else
      failed = true
      logger.error "❌ #{response.code} #{url}"
    end
  end
end
threads.each(&:join)

if failed
  logger.warn 'Please fix broken documentation links.'
  exit 1
end
