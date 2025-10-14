# frozen_string_literal: true

require "uri"

module Peddler
  Endpoint = Data.define(:aws_region, :selling_region, :host) do
    # @see https://developer-docs.amazon.com/sp-api/docs/sp-api-endpoints
    REGIONS = { # steep:ignore
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
    }

    class << self
      # @return [Array<Endpoint>]
      def all
        REGIONS.map { |aws_region, values| new(**values, aws_region: aws_region) } # steep:ignore
      end

      # @param [String] aws_region
      def find(aws_region)
        values = REGIONS.fetch(aws_region) do # steep:ignore
          raise ArgumentError, "#{aws_region} not found"
        end

        new(**values, aws_region: aws_region)
      end

      # @param [String] selling_region
      def find_by_selling_region(selling_region)
        aws_region, values = REGIONS.find { |_, v| v[:selling_region] == selling_region } || # steep:ignore
          raise(ArgumentError, "#{selling_region} not found")

        new(**values, aws_region: aws_region)
      end
    end

    # steep:ignore:start
    # @return [URI]
    def production
      URI::HTTPS.build(host: host)
    end

    # @return [URI]
    def sandbox
      URI::HTTPS.build(host: "sandbox.#{host}")
    end
    # steep:ignore:end
  end
end
