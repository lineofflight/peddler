# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # The pagination elements required to retrieve the remaining data.
      Pagination = Structure.new do
        # @return [String] Pagination occurs when a request produces a response that exceeds the `pageSize`. This means
        # that the response is divided into individual pages. To retrieve the next page or the previous page, you must
        # pass the `nextToken` value or the `previousToken` value as the `pageToken` parameter in the next request.
        # There is no `nextToken` in the pagination object on the last page.
        attribute(:next_token, String, from: "nextToken")
      end
    end
  end
end
