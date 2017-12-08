# frozen_string_literal: true

require 'peddler/xml_parser'

module Peddler
  # @api private
  class XMLResponseParser < XMLParser
    MATCHER = /^Message$|Report|Result/
    private_constant :MATCHER

    def next_token
      parse.fetch('NextToken', false)
    end

    private

    def find_data
      payload = xml.values.first
      found = payload.find { |k, _| k.match(MATCHER) }

      found.last if found
    end
  end
end
