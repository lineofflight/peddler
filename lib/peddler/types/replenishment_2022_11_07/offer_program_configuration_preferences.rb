# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Replenishment20221107
      # An object which contains the preferences applied to the offer.
      OfferProgramConfigurationPreferences = Structure.new do
        # @return [String] The auto-enrollment preference indicates whether the offer is opted-in to or opted-out of
        # Amazon's auto-enrollment feature.
        attribute?(:auto_enrollment, String, from: "autoEnrollment")
      end
    end
  end
end
