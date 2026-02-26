# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      PrimeInformation = Structure.new do
        # @return [:boolean] Indicates whether the offer is an Amazon Prime offer throughout the entire marketplace
        #   where it is listed
        attribute?(:national_prime, :boolean, from: "IsNationalPrime")

        # @return [:boolean] Indicates whether the offer is an Amazon Prime offer
        attribute?(:prime, :boolean, from: "IsPrime")
      end
    end
  end
end
