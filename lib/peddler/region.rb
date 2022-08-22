# frozen_string_literal: true

require "uri"

module Peddler
  class Region
    class UnknownRegion < ArgumentError; end

    # @see https://developer-docs.amazon.com/sp-api/docs/sp-api-endpoints
    ENDPOINTS = {
      "us-east-1" => "https://sellingpartnerapi-na.amazon.com",
      "us-west-2" => "https://sellingpartnerapi-fe.amazon.com",
      "eu-west-1" => "https://sellingpartnerapi-eu.amazon.com",
    }

    attr_reader :name

    # @param [String] name
    def initialize(name)
      @name = name
    end

    # @return [String]
    def endpoint
      ENDPOINTS.fetch(name) do
        raise UnknownRegion, "#{name} not found"
      end
    end
  end
end
