require 'delegate'
require 'dig_rb'
require 'forwardable'
require 'multi_xml'

module Peddler
  # @api private
  class XMLParser < SimpleDelegator
    extend Forwardable

    def_delegator :parse, :dig

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
      raise NotImplementedError
    end
  end
end
