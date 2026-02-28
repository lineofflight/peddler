# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Client Reference Details
      ClientReferenceDetail = Structure.new do
        # @return [String] The Client Reference Id.
        attribute(:client_reference_id, String, null: false, from: "clientReferenceId")

        # @return [String] Client Reference type.
        attribute(:client_reference_type, String, null: false, from: "clientReferenceType")
      end
    end
  end
end
