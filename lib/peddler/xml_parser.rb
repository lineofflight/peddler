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

    def valid?
      headers['Content-Length'].to_i == body.size if headers['Content-Length']
    end

    private

    def find_result
      xml.values[0].find { |k, v| k.include?('Result') }.last
    end
  end
end
