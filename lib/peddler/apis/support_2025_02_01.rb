# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Support
    #
    # The Selling Partner API for Support provides programmatic access to information about Selling Partner support.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/support-api-model/support_2025-02-01.json
    class Support20250201 < API
      # Retrieve support cases for a selling partner.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body for the listCases operation.
      # @return [Peddler::Response] The API response
      def list_cases(body)
        path = "/support/2025-02-01/cases"
        parser = -> { ListCasesResult }
        post(path, body:, parser:)
      end

      # Retrieve a specific support case.
      #
      # @note This operation can make a static sandbox call.
      # @param case_id [String] The case identifier.
      # @return [Peddler::Response] The API response
      def get_case(case_id)
        path = "/support/2025-02-01/cases/#{percent_encode(case_id)}"
        parser = -> { Case }
        get(path, parser:)
      end

      # Retrieve contacts for a specific support case.
      #
      # @note This operation can make a static sandbox call.
      # @param case_id [String] The case identifier.
      # @param max_results [Integer] The maximum number of results to include in the response.
      # @param next_token [String] A token to retrieve the next page of results. The response includes `nextToken` when
      #   the number of results exceeds the specified `maxResults` value. To get the next page of results, call the
      #   operation with this token and include the same arguments as the call that produced the token. To get a
      #   complete list, call this operation until `nextToken` is null. Note that this operation can return empty pages.
      # @param sort_order [String] Sort the returned contacts by `createdDate` in either ascending or descending order.
      # @return [Peddler::Response] The API response
      def list_contacts(case_id, max_results: 10, next_token: nil, sort_order: "DESC")
        path = "/support/2025-02-01/cases/#{percent_encode(case_id)}/contacts"
        params = {
          "maxResults" => max_results,
          "nextToken" => next_token,
          "sortOrder" => sort_order,
        }.compact
        parser = -> { ListContactsResult }
        get(path, params:, parser:)
      end
    end
  end
end
