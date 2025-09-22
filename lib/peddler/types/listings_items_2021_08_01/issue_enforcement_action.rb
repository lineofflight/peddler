# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ListingsItems20210801
      # The enforcement action taken by Amazon that affect the publishing or status of a listing
      IssueEnforcementAction = Structure.new do
        # @return [String] The enforcement action name.
        #
        # Possible values:
        #
        # * `LISTING_SUPPRESSED` - This enforcement takes down the current listing item's buyability.
        #
        # * `ATTRIBUTE_SUPPRESSED` - An attribute's value on the listing item is invalid, which causes it to be rejected
        # by Amazon.
        #
        # * `CATALOG_ITEM_REMOVED` - This catalog item is inactive on Amazon, and all offers against it in the
        # applicable marketplace are non-buyable.
        #
        # * `SEARCH_SUPPRESSED` - This value indicates that the catalog item is hidden from search results.
        attribute(:action, String)
      end
    end
  end
end
