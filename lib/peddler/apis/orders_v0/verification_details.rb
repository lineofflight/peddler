# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Additional information related to the verification of a regulated order.
      VerificationDetails = Structure.new do
        # @return [PrescriptionDetail] Information regarding the prescription tied to the order.
        attribute?(:prescription_detail, PrescriptionDetail, from: "prescriptionDetail")
      end
    end
  end
end
