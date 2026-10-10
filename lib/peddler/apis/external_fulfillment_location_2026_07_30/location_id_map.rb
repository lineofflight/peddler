# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentLocation20260730
      # A map of channel to location identifier.
      LocationIdMap = Structure.new do
        # The location identifier for the FBA channel.
        attribute?(:fba, String, from: "FBA")

        # The location identifier for the MFN channel.
        attribute?(:mfn, String, from: "MFN")
      end
    end
  end
end
