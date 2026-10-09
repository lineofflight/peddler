# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Listings Restrictions
    #
    # The Selling Partner API for Listings Restrictions provides programmatic access to restrictions on Amazon catalog
    # listings.
    #
    # For more information, see the
    # {https://developer-docs.amazon.com/sp-api/docs/listings-restrictions-api-v2021-08-01-use-case-guide Listings
    # Restrictions API Use Case Guide}.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/listings-restrictions-api-model/listingsRestrictions_2021-08-01.json
    module ListingsRestrictions20210801
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "listings_restrictions_2021_08_01.get_listings_restrictions" => -> { RestrictionList },
      })
    end
  end
end
