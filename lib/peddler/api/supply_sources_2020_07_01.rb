# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Supply Sources
    #
    # Manage configurations and capabilities of seller supply sources.
    class SupplySources20200701 < API
      # The path to retrieve paginated supply sources.
      #
      # @param [String] next_page_token The pagination token to retrieve a specific page of results.
      # @param [Number] page_size The number of supply sources to return per paginated request.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_supply_sources(next_page_token: nil, page_size: 10, rate_limit: nil)
        cannot_sandbox!

        path = "/supplySources/2020-07-01/supplySources"
        params = {
          "nextPageToken" => next_page_token,
          "pageSize" => page_size,
        }.compact

        get(path, params:)
      end

      # Create a new supply source.
      #
      # @param [Hash] payload A request to create a supply source.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def create_supply_source(payload, rate_limit: nil)
        cannot_sandbox!

        path = "/supplySources/2020-07-01/supplySources"
        body = payload

        post(path, body:)
      end

      # Retrieve a supply source.
      #
      # @param [String] supply_source_id The unique identifier of a supply source.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_supply_source(supply_source_id, rate_limit: nil)
        cannot_sandbox!

        path = "/supplySources/2020-07-01/supplySources/#{supply_source_id}"

        get(path)
      end

      # Update the configuration and capabilities of a supply source.
      #
      # @param [String] supply_source_id The unique identitier of a supply source.
      # @param [Hash] payload
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def update_supply_source(supply_source_id, payload: nil, rate_limit: nil)
        cannot_sandbox!

        path = "/supplySources/2020-07-01/supplySources/#{supply_source_id}"
        body = payload

        put(path, body:)
      end

      # Archive a supply source, making it inactive. Cannot be undone.
      #
      # @param [String] supply_source_id The unique identifier of a supply source.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def archive_supply_source(supply_source_id, rate_limit: nil)
        cannot_sandbox!

        path = "/supplySources/2020-07-01/supplySources/#{supply_source_id}"

        delete(path)
      end

      # Update the status of a supply source.
      #
      # @param [String] supply_source_id The unique identifier of a supply source.
      # @param [Hash] payload
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def update_supply_source_status(supply_source_id, payload: nil, rate_limit: nil)
        cannot_sandbox!

        path = "/supplySources/2020-07-01/supplySources/#{supply_source_id}/status"
        body = payload

        put(path, body:)
      end
    end
  end
end
