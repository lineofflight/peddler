# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # Amazon Prime information.
      PrimeInformationType = Structure.new do
        # @return [:boolean] Indicates whether the offer is an Amazon Prime offer.
        attribute(:prime, :boolean, from: "IsPrime")

        # @return [:boolean] Indicates whether the offer is an Amazon Prime offer throughout the entire marketplace
        # where it is listed.
        attribute(:national_prime, :boolean, from: "IsNationalPrime")
      end
    end
  end
end
