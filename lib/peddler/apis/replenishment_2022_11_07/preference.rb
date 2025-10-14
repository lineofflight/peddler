# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # Offer preferences that you can include in the result filter criteria.
      Preference = Structure.new do
        # @return [Array<AutoEnrollmentPreference>] Filters the results to only include offers with the auto-enrollment
        # preference specified.
        attribute?(:auto_enrollment, Array, from: "autoEnrollment")
      end
    end
  end
end
