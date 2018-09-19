# frozen_string_literal: true

require 'delegate'
require 'forwardable'
require 'peddler/headers'
require 'multi_xml'

module Peddler
  # @api private
  class XMLParser < SimpleDelegator
    extend Forwardable
    include Headers

    def_delegator :parse, :dig

    def data
      @data ||= find_data
    end

    alias parse data

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
