# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Support20250201
      # The request body for the listCases operation.
      ListCasesRequest = Structure.new do
        # @return [CaseFilters] Optional filters to narrow the returned collection. When absent, the operation returns
        #   all cases for the requesting identity.
        attribute?(:case_filters, CaseFilters, from: "caseFilters")

        # @return [String] The marketplace identifier used for authorization only. This field does not impact the
        #   returned collection. For a list of possible values, refer to [Marketplace
        #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [Integer] Maximum number of results to return.
        attribute?(:max_results, Integer, from: "maxResults")

        # @return [String] A token to retrieve the next page of results. The response includes `nextToken` when the
        #   number of results exceeds the specified `maxResults` value. To get the next page of results, call the
        #   operation with this token and include the same arguments as the call that produced the token. To get a
        #   complete list, call this operation until `nextToken` is null. Note that this operation can return empty
        #   pages.
        attribute?(:next_token, String, from: "nextToken")

        # @return [String] The field to sort cases by. Defaults to CREATION_DATE when absent.
        attribute?(:sort_field, String, from: "sortField")

        # @return [String] The sort direction. Defaults to DESC when absent.
        attribute?(:sort_order, String, from: "sortOrder")
      end
    end
  end
end
