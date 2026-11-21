# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The Response for the LinkCarrierAccount operation.
      LinkCarrierAccountResponse = Structure.new do
        attribute?(:account_id, String, from: "accountId")

        # Known values: `ACTIVE`, `INACTIVE`, `PENDING`, `SUSPENDED`.
        attribute?(:registration_status, String, from: "registrationStatus")
      end
    end
  end
end
