# frozen_string_literal: true

require 'open3'
require 'net/http'
require 'logger'

logger = Logger.new(STDOUT)

search_command = 'grep -R @see ./lib'
output, = Open3.capture3(search_command)
matches = output.split("\n")

failed = false

matches.each do |line|
  url = line.match(/http.*/)[0]
  logger.info "Fetching #{url} ..."

  response = Net::HTTP.get_response(URI(url))

  case response
  when Net::HTTPSuccess, Net::HTTPRedirection
    logger.info 'Success.'
  else
    failed = true
    logger.error 'Failed.'
  end
end

if failed
  logger.warn 'Please fix broken documentation links.'
  exit 1
end
