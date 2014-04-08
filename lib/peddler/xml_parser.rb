require 'delegate'
require 'multi_xml'

module Peddler
  # @api private
  class XMLParser < SimpleDelegator
    def next_token
      parse.fetch('NextToken', false)
    end

    def parse
      @result ||= find_result
    end

    def xml
      MultiXml.parse(body)
    end

    private

    def find_result
      xml.values[0].find { |k, v| k.include?('Result') }.last
    end
  end
end
