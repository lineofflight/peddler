require 'delegate'
require 'multi_xml'

module Peddler
  # @api private
  class XMLParser < SimpleDelegator
    def parse
      @data ||= find_data
    end

    def xml
      MultiXml.parse(body)
    end

    def valid?
      return unless headers['Content-Length']
      headers['Content-Length'].to_i == body.size
    end

    private

    def find_data
      fail NotImplementedError
    end
  end
end
