# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Client Reference Details
      ClientReferenceDetail = Structure.new do
        # The Client Reference Id.
        attribute(:client_reference_id, String, null: false, from: "clientReferenceId")

        # Client Reference type. Known values: `IntegratorShipperId`, `IntegratorMerchantId`.
        attribute(:client_reference_type, String, null: false, from: "clientReferenceType")
      end
    end
  end
end
