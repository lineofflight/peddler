# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Listings Items
    #
    # The Selling Partner API for Listings Items (Listings Items API) provides programmatic access to selling partner
    # listings on Amazon. Use this API in collaboration with the Selling Partner API for Product Type Definitions, which
    # you use to retrieve the information about Amazon product types needed to use the Listings Items API.
    #
    # For more information, see the
    # {https://developer-docs.amazon.com/sp-api/docs/listings-items-api-v2020-09-01-use-case-guide Listing Items API Use
    # Case Guide}.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/listings-items-api-model/listingsItems_2020-09-01.json
    module ListingsItems20200901
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "listings_items_2020_09_01.delete_listings_item" => -> { ListingsItemSubmissionResponse },
        "listings_items_2020_09_01.patch_listings_item" => -> { ListingsItemSubmissionResponse },
        "listings_items_2020_09_01.put_listings_item" => -> { ListingsItemSubmissionResponse },
      })
    end
  end
end
