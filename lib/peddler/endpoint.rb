# frozen_string_literal: true

require "uri"

module Peddler
  class Endpoint < Data.define(:aws_region, :selling_region, :host)
    # @see https://developer-docs.amazon.com/sp-api/docs/sp-api-endpoints
    REGIONS = {
      "us-east-1" => {
        selling_region: "North America",
        host: "sellingpartnerapi-na.amazon.com",
      },
      "us-west-2" => {
        selling_region: "Far East",
        host: "sellingpartnerapi-fe.amazon.com",
      },
      "eu-west-1" => {
        selling_region: "Europe",
        host: "sellingpartnerapi-eu.amazon.com",
      },
    }.freeze

    class << self
      # @return [Array<Endpoint>]
      def all
        REGIONS.map { |aws_region, values| new(**values, aws_region: aws_region) }
      end

      # @param [String] aws_region
      def find(aws_region)
        values = REGIONS.fetch(aws_region) do
          raise ArgumentError, "#{aws_region} not found"
        end

        new(**values, aws_region: aws_region)
      end

      # @param [String] selling_region
      def find_by_selling_region(selling_region)
        aws_region, values = REGIONS.find { |_, v| v[:selling_region] == selling_region } ||
          raise(ArgumentError, "#{selling_region} not found")

        new(**values, aws_region: aws_region)
      end
    end

    # @return [URI]
    def production
      URI::HTTPS.build(host: host)
    end

    # @return [URI]
    def sandbox
      URI::HTTPS.build(host: "sandbox.#{host}")
    end
  end
end
