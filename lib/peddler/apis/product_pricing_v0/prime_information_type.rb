# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Amazon Prime information.
      PrimeInformationType = Structure.new do
        # @return [:boolean] Indicates whether the offer is an Amazon Prime offer throughout the entire marketplace
        #   where it is listed.
        attribute(:national_prime, :boolean, null: false, from: "IsNationalPrime")

        # @return [:boolean] Indicates whether the offer is an Amazon Prime offer.
        attribute(:prime, :boolean, null: false, from: "IsPrime")
      end
    end
  end
end
