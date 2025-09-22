# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/replenishment_2022_11_07/offer_program_configuration_preferences"
require "peddler/types/replenishment_2022_11_07/offer_program_configuration_promotions"

module Peddler
  module Types
    module Replenishment20221107
      # The offer program configuration contains a set of program properties for an offer.
      OfferProgramConfiguration = Structure.new do
        # @return [OfferProgramConfigurationPreferences] An object which contains the preferences applied to the offer.
        attribute(:preferences, OfferProgramConfigurationPreferences)

        # @return [OfferProgramConfigurationPromotions] An object which contains the promotions applied to the offer.
        attribute(:promotions, OfferProgramConfigurationPromotions)

        # @return [String] Determines whether the offer was automatically or manually enrolled in the program. This
        # property is only supported for sellers and not vendors.
        attribute(:enrollment_method, String, from: "enrollmentMethod")
      end
    end
  end
end
