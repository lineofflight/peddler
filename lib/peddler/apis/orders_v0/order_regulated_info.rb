# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The order's regulated information along with its verification status.
      OrderRegulatedInfo = Structure.new do
        # @return [String] An Amazon-defined order identifier, in 3-7-7 format.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [RegulatedInformation] The regulated information collected during purchase and used to verify the
        #   order.
        attribute(:regulated_information, RegulatedInformation, from: "RegulatedInformation")

        # @return [RegulatedOrderVerificationStatus] The order's verification status.
        attribute(:regulated_order_verification_status, RegulatedOrderVerificationStatus, from: "RegulatedOrderVerificationStatus")

        # @return [:boolean] When true, the order requires attaching a dosage information label when shipped.
        attribute(:requires_dosage_label, :boolean, from: "RequiresDosageLabel")
      end
    end
  end
end
