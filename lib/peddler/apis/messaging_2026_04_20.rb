# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Messaging Automations
    #
    # The Selling Partner API for Messaging Automations allows sellers to programmatically manage automated buyer-seller
    # messaging configurations. An automation configuration defines rules for automatically responding to buyer messages
    # (for example, auto-responses to common questions about shipping, returns, or product details). A seller can create
    # multiple automation configurations, and each configuration can apply to one or more Amazon stores. Each
    # store-specific entry within a configuration contains the response content and the automation trigger conditions.
    # The `marketplaceIds` query parameter is required on all operations for store-scoped authorization.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/messaging-api-model/messaging_2026-04-20.json
    class Messaging20260420 < API
      # Creates a new automation configuration for automated buyer-seller messaging. The configuration is `ACTIVE` as
      # soon as it is created. The response returns the full automation configuration resource, including the
      # server-generated `automationId`.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_ids [Array<String>] A comma-delimited list of [Amazon store
      #   identifiers](https://developer-docs.amazon/sp-api/docs/marketplace-ids) for the request. Required for
      #   store-scoped operations and authorization. Your application must have permission to operate in the specified
      #   stores before processing the request body.
      # @param body [Hash] The request body for creating an automation configuration.
      # @return [Peddler::Response] The API response
      def create_automation_configuration(marketplace_ids, body)
        path = "/messaging/2026-04-20/automationConfigurations"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = -> { AutomationConfiguration }
        post(path, body:, params:, parser:)
      end

      # Returns a list of automation configurations that include the specified Amazon store. Results may include
      # configurations that also apply to other stores, since a single configuration can span multiple stores.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_ids [Array<String>] A comma-delimited list of [Amazon store
      #   identifiers](https://developer-docs.amazon/sp-api/docs/marketplace-ids) for the request. Required for
      #   store-scoped operations and authorization. Your application must have permission to operate in the specified
      #   stores before processing the request body.
      # @param automation_type [String] Filters results by automation type. Known values: `AUTO_RESPONSE`.
      # @param automation_sub_type [String] Filters results by automation sub-type. Known values: `AUTO_RESPONSE`.
      # @param include_marketplace_automations [String] When set to `true`, the response includes the full, store-level
      #   automation details for each configuration, including response text, attachment URL, and the trigger conditions
      #   that define when the automation activates for that store. When false or omitted, only the top-level
      #   configuration metadata (identifier, status, display name, timestamps) is returned. Known values: `TRUE`,
      #   `FALSE`.
      # @param page_size [Integer] The number of results to return per page. Minimum: 1. Maximum: 50. Default: 10.
      # @param pagination_token [String] A token to fetch the next page of results. Use the `nextToken` value returned
      #   in the previous response's `pagination` object.
      # @return [Peddler::Response] The API response
      def list_automation_configurations(marketplace_ids, automation_type: nil, automation_sub_type: nil,
        include_marketplace_automations: "FALSE", page_size: nil, pagination_token: nil)
        path = "/messaging/2026-04-20/automationConfigurations"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "automationType" => automation_type,
          "automationSubType" => automation_sub_type,
          "includeMarketplaceAutomations" => include_marketplace_automations,
          "pageSize" => page_size,
          "paginationToken" => pagination_token,
        }.compact
        parser = -> { ListAutomationConfigsResponse }
        get(path, params:, parser:)
      end

      # Returns the details of a specific automation configuration, including its store-specific automation entries with
      # response content and trigger conditions.
      #
      # @note This operation can make a static sandbox call.
      # @param automation_id [String] The unique identifier of the automation configuration.
      # @param marketplace_ids [Array<String>] A comma-delimited list of [Amazon store
      #   identifiers](https://developer-docs.amazon/sp-api/docs/marketplace-ids) for the request. Required for
      #   store-scoped operations and authorization. Your application must have permission to operate in the specified
      #   stores before processing the request body.
      # @return [Peddler::Response] The API response
      def get_automation_configuration(automation_id, marketplace_ids)
        path = "/messaging/2026-04-20/automationConfigurations/#{percent_encode(automation_id)}"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = -> { AutomationConfiguration }
        get(path, params:, parser:)
      end

      # Updates an existing automation configuration. This is a full replacement operation using `PUT` semantics; you
      # must provide the complete desired state, including `automationDisplayName`, `automationStatus`, and
      # `marketplaceAutomations`. The `marketplaceAutomations` entries you provide replace all of the configuration's
      # existing Amazon store entries; any store that you omit is removed from the configuration. To deactivate a
      # configuration, send its complete current state with `automationStatus` set to `DEACTIVATED`.
      #
      # @note This operation can make a static sandbox call.
      # @param automation_id [String] The unique identifier of the automation configuration to update.
      # @param marketplace_ids [Array<String>] A comma-delimited list of [Amazon store
      #   identifiers](https://developer-docs.amazon/sp-api/docs/marketplace-ids) for the request. Required for
      #   store-scoped operations and authorization. Your application must have permission to operate in the specified
      #   stores before processing the request body.
      # @param body [Hash] The request body for updating an automation configuration.
      # @return [Peddler::Response] The API response
      def update_automation_configuration(automation_id, marketplace_ids, body)
        path = "/messaging/2026-04-20/automationConfigurations/#{percent_encode(automation_id)}"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = -> { AutomationConfiguration }
        put(path, body:, params:, parser:)
      end
    end
  end
end
