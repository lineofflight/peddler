require 'peddler/xml_parser'

module Peddler
  # @api private
  class XMLResponseParser < XMLParser
    def next_token
      parse.fetch('NextToken', false)
    end

    private

    def find_data
      results = xml.values.first.find { |k, _| k.include?('Result') } ||
                xml.values.first.find { |k, _| k == 'Message' }

      results ? results.last : nil
    end
  end
end
