# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # The offer program configuration contains a set of program properties for an offer.
      OfferProgramConfiguration = Structure.new do
        # @return [String] Determines whether the offer was automatically or manually enrolled in the program. This
        #   property is only supported for sellers and not vendors.
        attribute?(:enrollment_method, String, from: "enrollmentMethod")

        # @return [OfferProgramConfigurationPreferences] An object which contains the preferences applied to the offer.
        attribute?(:preferences, OfferProgramConfigurationPreferences)

        # @return [OfferProgramConfigurationPromotions] An object which contains the promotions applied to the offer.
        attribute?(:promotions, OfferProgramConfigurationPromotions)
      end
    end
  end
end
