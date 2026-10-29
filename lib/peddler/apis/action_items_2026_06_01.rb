# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Action Items
    #
    # The Selling Partner API for Action Items enables you to discover and inspect action items surfaced by Amazon,
    # including recommendations, issues, and tasks.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/action-items-api-model/actionItems_2026-06-01.json
    class ActionItems20260601 < API
      # Retrieve a paginated, filterable list of action items for the selling partner. When you specify multiple
      # filters, only action items that match all of them are returned. When you specify multiple values for one filter,
      # action items that match any of those values are returned.
      #
      # @note This operation can make a static sandbox call.
      # @param statuses [Array<String>] Filter by status (OR match). Known values: `PENDING_SELLING_PARTNER`,
      #   `AUTOMATABLE`, `DISMISSABLE`, `SNOOZABLE`, `DISMISSED`, `SNOOZED`, `OVERDUE`, `ACTIONED`, `RESOLVED`.
      # @param classifications [Array<String>] Filter by classification (OR match). Known values: `ISSUE`,
      #   `RECOMMENDATION`, `TASK`.
      # @param type_definition_ids [Array<String>] Filter by action item type definition IDs. Multiple values allowed.
      # @param marketplace_ids [Array<String>] Filter by marketplace IDs.
      # @param updated_after [String] Retrieve items last updated at or after this time. When used with `updatedBefore`,
      #   this value must be earlier than `updatedBefore`.
      # @param updated_before [String] Retrieve items last updated at or before this time. When used with
      #   `updatedAfter`, this value must be later than `updatedAfter`.
      # @param included_data [Array<String>] A list of optional datasets to include in the response. When omitted, only
      #   core action item fields are returned. Known values: `impacts`, `resolutions`, `references`, `refinements`.
      # @param sort_by [String] How to sort results. Defaults to recommended. Known values: `lastUpdatedDate`,
      #   `recommended`.
      # @param sort_order [String] The sort order. Defaults to `DESC`. Known values: `ASC`, `DESC`.
      # @param page_size [Integer] Number of results per page.
      # @param page_token [String] A token to retrieve a specific page of results. Pass the nextToken or previousToken
      #   value from a previous response.
      # @param locale [String] The BCP 47 locale for localized content. Defaults to `en-US`.
      # @return [Peddler::Response] The API response
      def list_action_items(statuses: nil, classifications: nil, type_definition_ids: nil, marketplace_ids: nil,
        updated_after: nil, updated_before: nil, included_data: nil, sort_by: "recommended", sort_order: "DESC",
        page_size: 10, page_token: nil, locale: nil)
        path = "/actionItems/2026-06-01/items"
        params = {
          "statuses" => stringify_array(statuses),
          "classifications" => stringify_array(classifications),
          "typeDefinitionIds" => stringify_array(type_definition_ids),
          "marketplaceIds" => stringify_array(marketplace_ids),
          "updatedAfter" => updated_after,
          "updatedBefore" => updated_before,
          "includedData" => stringify_array(included_data),
          "sortBy" => sort_by,
          "sortOrder" => sort_order,
          "pageSize" => page_size,
          "pageToken" => page_token,
          "locale" => locale,
        }.compact
        parser = -> { ListActionItemsResponse }
        get(path, params:, parser:)
      end

      # Retrieve a single action item by ID with full detail.
      #
      # @note This operation can make a static sandbox call.
      # @param action_item_id [String] The unique identifier of the action item.
      # @param locale [String] The BCP 47 locale for localized content. Defaults to `en-US`.
      # @param included_data [Array<String>] A list of optional datasets to include in the response. When omitted, only
      #   core action item fields are returned. Known values: `impacts`, `resolutions`, `references`.
      # @return [Peddler::Response] The API response
      def get_action_item(action_item_id, locale: nil, included_data: nil)
        path = "/actionItems/2026-06-01/items/#{percent_encode(action_item_id)}"
        params = {
          "locale" => locale,
          "includedData" => stringify_array(included_data),
        }.compact
        parser = -> { GetActionItemResponse }
        get(path, params:, parser:)
      end

      # Dismiss the specified action item. An optional reason can be provided.
      #
      # @note This operation can make a static sandbox call.
      # @param action_item_id [String] The unique identifier of the action item.
      # @param body [Hash] The request body for the dismissActionItem operation.
      # @return [Peddler::Response] The API response
      def dismiss_action_item(action_item_id, body)
        path = "/actionItems/2026-06-01/items/#{percent_encode(action_item_id)}/dismissals"
        parser = -> { DismissActionItemResponse }
        post(path, body:, parser:)
      end
    end
  end
end
