require 'delegate'
require 'multi_xml'

module Peddler
  # A thin wrapper around an Excon::Response.
  class Response < SimpleDelegator
    # Parse response body into Ruby.
    #
    # Returns a Hash.
    def to_hash
      MultiXml.parse(body)
    end
  end
end
