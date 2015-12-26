require 'peddler/xml_parser'

module Peddler
  # @api private
  class XMLResponseParser < XMLParser
    def next_token
      parse.fetch('NextToken', false)
    end

    private

    def find_data
      payload = xml.values.first
      found = payload.find { |k, _| k.include?('Result') } ||
              payload.find { |k, _| k == 'Message' }

      found.last if found
    end
  end
end
