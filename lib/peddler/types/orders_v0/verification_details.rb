# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/prescription_detail"

module Peddler
  module Types
    module OrdersV0
      # Additional information related to the verification of a regulated order.
      VerificationDetails = Structure.new do
        # @return [PrescriptionDetail] Information regarding the prescription tied to the order.
        attribute?(:prescription_detail, PrescriptionDetail, from: "prescriptionDetail")
      end
    end
  end
end
