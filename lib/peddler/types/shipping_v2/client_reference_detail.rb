# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Client Reference Details
      ClientReferenceDetail = Structure.new do
        # @return [String] Client Reference type.
        attribute(:client_reference_type, String, from: "clientReferenceType")

        # @return [String] The Client Reference Id.
        attribute(:client_reference_id, String, from: "clientReferenceId")
      end
    end
  end
end
