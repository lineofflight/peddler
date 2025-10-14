# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      PrimeInformation = Structure.new do
        # @return [:boolean] Indicates whether the offer is an Amazon Prime offer throughout the entire marketplace
        # where it is listed.
        attribute(:offer_national_prime, :boolean, from: "isOfferNationalPrime")

        # @return [:boolean] Indicates whether the offer is an Amazon Prime offer.
        attribute(:offer_prime, :boolean, from: "isOfferPrime")
      end
    end
  end
end
