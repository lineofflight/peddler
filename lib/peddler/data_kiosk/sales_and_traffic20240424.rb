# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module DataKiosk
    module SalesAndTraffic20240424
      class << self
        # Get the GraphQL schema for this data kiosk
        #
        # @return [Hash] GraphQL schema introspection data
        # @example Load with graphql-client
        #   schema = Peddler::DataKiosk::SalesAndTraffic20240424.schema
        #   client = GraphQL::Client.load_schema(schema)
        def schema
          path = File.expand_path("sales_and_traffic20240424.json", __dir__.to_s)
          JSON.load_file(path)
        end
      end
    end
  end
end
