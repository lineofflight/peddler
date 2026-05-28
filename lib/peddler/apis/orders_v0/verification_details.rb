# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Additional information related to the verification of a regulated order.
      VerificationDetails = Structure.new do
        # @return [Array<ApprovedAttribute>] Pre-approved alternative product attributes provided when a vet rejects an
        #   order but suggests a correction. Only valid when the verification status is `Rejected`.
        attribute?(:approved_alternative_details, [ApprovedAttribute], from: "approvedAlternativeDetails")

        # @return [InterimStatusDetail] Interim status information provided during the verification process. Only valid
        #   when the verification status is `Pending`.
        attribute?(:interim_status_detail, InterimStatusDetail, from: "interimStatusDetail")

        # @return [PrescriptionDetail] Information regarding the prescription tied to the order.
        attribute?(:prescription_detail, PrescriptionDetail, from: "prescriptionDetail")
      end
    end
  end
end
