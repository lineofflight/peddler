# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # The carrier data that determined the transit time, and the source that supplied the data.
      TransitTimeInput = Structure.new do
        # @return [String] The source of the transit time data.
        #
        # **Possible values**:
        # - `AMAZON_AUTOMATED` (Amazon selected the shipping service using settings generated on the seller's behalf.) -
        #   `SELLER_SET` (The seller configured the transit time through a shipping template they maintain.) -
        #   `THIRD_PARTY_INTEGRATOR` (The transit time came from a live shipping quote that Amazon obtained from a
        #   third-party integrator for the seller's order.)
        attribute?(:data_source, String, from: "dataSource")

        # @return [TransitTimeInputDetails] The carrier and shipping service used to calculate the transit time.
        attribute?(:details, TransitTimeInputDetails)
      end
    end
  end
end
