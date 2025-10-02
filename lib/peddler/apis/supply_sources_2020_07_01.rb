# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def supply_sources_2020_07_01
      typed? ? APIs::SupplySources20200701.typed : APIs::SupplySources20200701
    end
  end

  module APIs
    # Selling Partner API for Supply Sources
    #
    # Manage configurations and capabilities of seller supply sources.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/supply-sources-api-model/supplySources_2020-07-01.json
    class SupplySources20200701 < API
      class << self
        # Enables typed response parsing
        # @return [self]
        def typed
          @typed = true
          require_relative "../types/supply_sources_2020_07_01"
          self
        end
      end

      # The path to retrieve paginated supply sources.
      #
      # @note This operation can make a static sandbox call.
      # @param next_page_token [String] The pagination token to retrieve a specific page of results.
      # @param page_size [Number] The number of supply sources to return per paginated request.
      # @return [Peddler::Response] The API response
      def get_supply_sources(next_page_token: nil, page_size: 10)
        path = "/supplySources/2020-07-01/supplySources"
        params = {
          "nextPageToken" => next_page_token,
          "pageSize" => page_size,
        }.compact
        parser = Peddler::Types::SupplySources20200701::GetSupplySourcesResponse if typed?
        get(path, params:, parser:)
      end

      # Create a new supply source.
      #
      # @note This operation can make a static sandbox call.
      # @param payload [Hash] A request to create a supply source.
      # @return [Peddler::Response] The API response
      def create_supply_source(payload)
        path = "/supplySources/2020-07-01/supplySources"
        body = payload
        parser = Peddler::Types::SupplySources20200701::CreateSupplySourceResponse if typed?
        post(path, body:, parser:)
      end

      # Retrieve a supply source.
      #
      # @note This operation can make a static sandbox call.
      # @param supply_source_id [String] The unique identifier of a supply source.
      # @return [Peddler::Response] The API response
      def get_supply_source(supply_source_id)
        path = "/supplySources/2020-07-01/supplySources/#{percent_encode(supply_source_id)}"
        parser = Peddler::Types::SupplySources20200701::SupplySource if typed?
        get(path, parser:)
      end

      # Update the configuration and capabilities of a supply source.
      #
      # @note This operation can make a static sandbox call.
      # @param supply_source_id [String] The unique identitier of a supply source.
      # @param payload [Hash]
      # @return [Peddler::Response] The API response
      def update_supply_source(supply_source_id, payload: nil)
        path = "/supplySources/2020-07-01/supplySources/#{percent_encode(supply_source_id)}"
        body = payload
        parser = Peddler::Types::SupplySources20200701::ErrorList if typed?
        put(path, body:, parser:)
      end

      # Archive a supply source, making it inactive. Cannot be undone.
      #
      # @note This operation can make a static sandbox call.
      # @param supply_source_id [String] The unique identifier of a supply source.
      # @return [Peddler::Response] The API response
      def archive_supply_source(supply_source_id)
        path = "/supplySources/2020-07-01/supplySources/#{percent_encode(supply_source_id)}"
        parser = Peddler::Types::SupplySources20200701::ErrorList if typed?
        delete(path, parser:)
      end

      # Update the status of a supply source.
      #
      # @note This operation can make a static sandbox call.
      # @param supply_source_id [String] The unique identifier of a supply source.
      # @param payload [Hash]
      # @return [Peddler::Response] The API response
      def update_supply_source_status(supply_source_id, payload: nil)
        path = "/supplySources/2020-07-01/supplySources/#{percent_encode(supply_source_id)}/status"
        body = payload
        parser = Peddler::Types::SupplySources20200701::ErrorList if typed?
        put(path, body:, parser:)
      end
    end
  end
end
