# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Result payload for successful ASN submission.
      SubmitShipmentConfirmationResult = Structure.new do
        # @return [String] Success message for the operation SubmitShipmentConfirmation
        attribute?(:message, String)
      end
    end
  end
end
