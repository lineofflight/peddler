# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `confirmTransportationOptions` request.
      ConfirmTransportationOptionsRequest = Structure.new do
        # @return [Array<TransportationSelection>] Information needed to confirm one of the available transportation
        #   options.
        attribute(:transportation_selections, [TransportationSelection], from: "transportationSelections")
      end
    end
  end
end
