# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module SellersV1
      # Information that is specific to a seller in a marketplace.
      Participation = Structure.new do
        # @return [:boolean] Specifies if the seller has suspended listings. `true` if the seller Listing Status is set
        # to Inactive, otherwise `false`.
        attribute(:has_suspended_listings, :boolean, from: "hasSuspendedListings")

        # @return [:boolean] If `true`, the seller participates in the marketplace. Otherwise `false`.
        attribute(:participating, :boolean, from: "isParticipating")
      end
    end
  end
end
