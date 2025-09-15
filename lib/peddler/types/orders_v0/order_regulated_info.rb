# frozen_string_literal: true

require "peddler/types/orders_v0/regulated_information"
require "peddler/types/orders_v0/regulated_order_verification_status"

module Peddler
  module Types
    module OrdersV0
      # The order's regulated information along with its verification status.
      OrderRegulatedInfo = Structure.new do
        # @return [String] An Amazon-defined order identifier, in 3-7-7 format.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [RegulatedInformation] The regulated information collected during purchase and used to verify the
        # order.
        attribute(:regulated_information, RegulatedInformation, from: "RegulatedInformation")

        # @return [:boolean] When true, the order requires attaching a dosage information label when shipped.
        attribute(:requires_dosage_label, :boolean, from: "RequiresDosageLabel")

        # @return [RegulatedOrderVerificationStatus] The order's verification status.
        attribute(:regulated_order_verification_status, RegulatedOrderVerificationStatus, from: "RegulatedOrderVerificationStatus")
      end
    end
  end
end
