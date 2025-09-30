# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Replenishment20221107
      # A promotional percentage discount applied to the offer.
      OfferProgramConfigurationPromotionsDiscountFunding = Structure.new do
        # @return [Float] The percentage discount on the offer.
        attribute?(:percentage, Float)
      end
    end
  end
end
