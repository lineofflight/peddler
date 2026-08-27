# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Promotions
    #
    # The Selling Partner API for Promotions enables selling partners to create and manage promotions.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/promotions-api-model/promotions_2025-12-01.json
    class Promotions20251201 < API
      # Search and filter promotions based on various criteria. Returns a paginated list of promotion summaries.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_ids [Array<String>] The Amazon stores from which to retrieve promotions. Refer to [Store
      #   Identifiers](https://developer-docs.amazon/sp-api/docs/store-identifiers) for a list of Amazon store values.
      # @param locale [String] The locale from which to retrieve promotions. Formatted as an ISO 639 language code,
      #   followed by an underscore, followed by an ISO 3166-1 alpha-2 country code.
      # @param statuses [Array<String>] The statuses of promotions to retrieve, formatted as a comma-delimited list.
      # @param asins [Array<String>] The ASINs to which promotions apply, formatted as a comma-delimited list.
      # @param skus [Array<String>] The SKUs to which promotions apply, formatted as a comma-delimited list.
      # @param promotion_types [Array<String>] The promotion types to which promotions apply, formatted as a
      #   comma-delimited list.
      # @param start_date_before [String] Promotions that start before this date are returned. Formatted in ISO 8601
      #   format, including the timezone. For example: `1970-01-01T00:00:00-07:00`.
      # @param start_date_after [String] Promotions that start after this date are returned. Formatted in ISO 8601
      #   format, including the timezone. For example: `1970-01-01T00:00:00-07:00`.
      # @param end_date_before [String] Promotions that end before this date are returned. Formatted in ISO 8601 format,
      #   including the timezone. For example: `1970-01-01T00:00:00-07:00`.
      # @param end_date_after [String] Promotions that end after this date are returned. Formatted in ISO 8601 format,
      #   including the timezone. For example: `1970-01-01T00:00:00-07:00`.
      # @param update_date_after [String] Filter promotions that were last modified after this timestamp. Zoned Datetime
      #   in ISO 8601 format (e.g., 1970-01-01T00:00:00-07:00).
      # @param update_date_before [String] Filter promotions that were last modified before this timestamp. Zoned
      #   Datetime in ISO 8601 format (e.g., 1970-01-01T00:00:00-07:00).
      # @param pagination_token [String] A token that you use to retrieve the next page of results. The response
      #   includes `paginationToken` when the number of results exceeds the specified `limit` value. To get the next
      #   page of results, call the operation with this token and include the same arguments as the call that produced
      #   the token. To get a complete list, call this operation until `paginationToken` is null. Note that this
      #   operation can return empty pages.
      # @param revision [String] Specifies which promotion revision or revisions to match against when filtering. This
      #   controls which promotions are included in search results, not the shape of the response. The response always
      #   returns the published revision in the main body, with `latestRevision` included when the latest revision
      #   diverges.
      # @param limit [Integer] The maximum number of response results per page.
      # @param included_data [Array<String>] A comma-delimited list of datasets to include in the response.
      # @return [Peddler::Response] The API response
      def search_promotions(marketplace_ids, locale: "en_US", statuses: nil, asins: nil, skus: nil,
        promotion_types: nil, start_date_before: nil, start_date_after: nil, end_date_before: nil, end_date_after: nil,
        update_date_after: nil, update_date_before: nil, pagination_token: nil, revision: "PUBLISHED", limit: 20,
        included_data: nil)
        path = "/promotions/2025-12-01/promotions"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "locale" => locale,
          "statuses" => stringify_array(statuses),
          "asins" => stringify_array(asins),
          "skus" => stringify_array(skus),
          "promotionTypes" => stringify_array(promotion_types),
          "startDateBefore" => start_date_before,
          "startDateAfter" => start_date_after,
          "endDateBefore" => end_date_before,
          "endDateAfter" => end_date_after,
          "updateDateAfter" => update_date_after,
          "updateDateBefore" => update_date_before,
          "paginationToken" => pagination_token,
          "revision" => revision,
          "limit" => limit,
          "includedData" => stringify_array(included_data),
        }.compact
        parser = -> { SearchPromotionsResponse }
        get(path, params:, parser:)
      end

      # Retrieve details of a specified promotion.
      #
      # @note This operation can make a static sandbox call.
      # @param promotion_id [String] The ID of the promotion.
      # @param included_data [Array<String>] A comma-delimited list of datasets to include in the response.
      # @param locale [String] The locale of the promotion. Formatted as an ISO 639 language code, followed by an
      #   underscore, followed by an ISO 3166-1 alpha-2 country code.
      # @return [Peddler::Response] The API response
      def get_promotion(promotion_id, included_data: nil, locale: "en_US")
        path = "/promotions/2025-12-01/promotions/#{percent_encode(promotion_id)}"
        params = {
          "includedData" => stringify_array(included_data),
          "locale" => locale,
        }.compact
        parser = -> { GetPromotionResponse }
        get(path, params:, parser:)
      end

      # Retrieve up to 100 product items that are associated with a specified promotion. This operation only supports
      # items found in `SelectionType.ITEMS`. Items found in `SelectionType.CATALOG` are not supported. Selection
      # objects always include `selectionDetails` with item information.
      #
      # @note This operation can make a static sandbox call.
      # @param promotion_id [String] The ID of the promotion.
      # @param selection_id [String] The ID of the selection.
      # @param revision_id [Integer] The revision identifier for the selection. Use the `revisionId` from the
      #   `getPromotion` response. A promotion may have multiple selection revisions when an update is in progress.
      #   Passing the correct `revisionId` ensures you retrieve the expected data.
      # @param locale [String] The locale of the promotion. Formatted as an ISO 639 language code, followed by an
      #   underscore, followed by an ISO 3166-1 alpha-2 country code.
      # @param pagination_token [String] A token that you use to retrieve the next page of results. The response
      #   includes `paginationToken` when the number of results exceeds the specified `limit` value. To get the next
      #   page of results, call the operation with this token and include the same arguments as the call that produced
      #   the token. To get a complete list, call this operation until `paginationToken` is null. Note that this
      #   operation can return empty pages.
      # @param limit [Integer] The maximum number of response results per page.
      # @param included_data [Array<String>] A comma-delimited list of datasets to include in the response.
      # @return [Peddler::Response] The API response
      def get_selection(promotion_id, selection_id, revision_id, locale: "en_US", pagination_token: nil, limit: 20,
        included_data: nil)
        path = "/promotions/2025-12-01/promotions/#{percent_encode(promotion_id)}/selections/#{percent_encode(selection_id)}"
        params = {
          "revisionId" => revision_id,
          "locale" => locale,
          "paginationToken" => pagination_token,
          "limit" => limit,
          "includedData" => stringify_array(included_data),
        }.compact
        parser = -> { GetSelectionResponse }
        get(path, params:, parser:)
      end
    end
  end
end
