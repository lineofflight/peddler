# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module SellersV1
      # Information that is specific to a seller in a marketplace.
      Participation = Structure.new do
        # @return [:boolean] If `true`, the seller participates in the marketplace. Otherwise `false`.
        attribute(:participating, :boolean, from: "isParticipating")

        # @return [:boolean] Specifies if the seller has suspended listings. `true` if the seller Listing Status is set
        # to Inactive, otherwise `false`.
        attribute(:has_suspended_listings, :boolean, from: "hasSuspendedListings")
      end
    end
  end
end
