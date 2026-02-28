# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      PrimeInformation = Structure.new do
        # @return [:boolean]
        attribute(:offer_national_prime, :boolean, null: false, from: "IsOfferNationalPrime")

        # @return [:boolean]
        attribute(:offer_prime, :boolean, null: false, from: "IsOfferPrime")
      end
    end
  end
end
