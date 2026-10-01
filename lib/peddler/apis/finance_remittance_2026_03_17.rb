# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Finance Remittance
    #
    # The Selling Partner API for Finance Remittance provides programmatic access to selling partner payment remittance
    # data, including remittance summaries and detailed line items.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/finance-remittance-api-model/financeRemittance-2026-03-17.json
    class FinanceRemittance20260317 < API
      # Returns a list of remittance summaries for the specified Amazon store, filtered by date range. Results are
      # paginated.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] The `marketplaceId` is a globally unique identifier used to specify which Amazon
      #   store a request is targeting. For more information, refer to [Store
      #   Identifiers](https://developer-docs.amazon/sp-api/docs/store-identifiers).
      # @param start_date [String] The earliest payment date for remittances to include in the response. Dates are in
      #   ISO 8601 date-time format. The default is 30 days prior to the time of the request. The minimum start date is
      #   one year ago from the current date.
      # @param end_date [String] The latest payment date for remittances to include in the response. Dates are in ISO
      #   8601 date-time format. The default is the current date-time. The maximum date range between `startDate` and
      #   `endDate` is 90 days.
      # @param next_token [String] A token to fetch the next page of results. Use the value returned in the previous
      #   response.
      # @return [Peddler::Response] The API response
      def get_remittance_headers(marketplace_id, start_date: nil, end_date: nil, next_token: nil)
        path = "/finances/remittances/2026-03-17/remittances"
        params = {
          "marketplaceId" => marketplace_id,
          "startDate" => start_date,
          "endDate" => end_date,
          "nextToken" => next_token,
        }.compact
        parser = -> { GetRemittancesResponse }
        get(path, params:, parser:)
      end

      # Returns detailed line items for a specific remittance. Results are paginated.
      #
      # @note This operation can make a static sandbox call.
      # @param unique_payment_id [String] The unique identifier for the payment.
      # @param marketplace_id [String] The `marketplaceId` is a globally unique identifier used to specify which Amazon
      #   store a request is targeting. For more information, refer to [Store
      #   Identifiers](https://developer-docs.amazon/sp-api/docs/store-identifiers).
      # @param next_token_for_line_items [String] A token to fetch the next page of results. Use the value returned in
      #   the previous response.
      # @return [Peddler::Response] The API response
      def get_remittance(unique_payment_id, marketplace_id, next_token_for_line_items: nil)
        path = "/finances/remittances/2026-03-17/remittances/#{percent_encode(unique_payment_id)}"
        params = {
          "marketplaceId" => marketplace_id,
          "nextTokenForLineItems" => next_token_for_line_items,
        }.compact
        parser = -> { GetRemittanceResponse }
        get(path, params:, parser:)
      end
    end
  end
end
