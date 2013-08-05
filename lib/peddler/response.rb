require 'delegate'
require 'forwardable'
require 'multi_xml'

module Peddler
  class Response < SimpleDelegator
    extend Forwardable

    def_delegator :parse, :[]

    # Parse response body into Ruby.
    #
    # Returns a Hash response.
    def parse
      MultiXml.parse(body).values.first.values[1]
    end
  end
end
