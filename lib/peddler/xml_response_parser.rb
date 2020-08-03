# frozen_string_literal: true

require 'peddler/xml_parser'

module Peddler
  # @!visibility private
  class XMLResponseParser < XMLParser
    MATCHER = /^Message$|^Node$|Report|Result/.freeze
    private_constant :MATCHER

    def next_token
      parse.fetch('NextToken', false)
    end

    private

    # FIXME: In next major version bump, stop assuming we know report internals.
    def find_data
      payload = xml.values.first
      found = payload.find { |k, _| k.match(MATCHER) }

      found&.last
    end
  end
end
