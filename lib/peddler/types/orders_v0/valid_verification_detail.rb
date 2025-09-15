# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module OrdersV0
      # The types of verification details that may be provided for the order and the criteria required for when the type
      # of verification detail can be provided. The types of verification details allowed depend on the type of
      # regulated product and will not change order to order.
      ValidVerificationDetail = Structure.new do
        # @return [String] A supported type of verification detail. The type indicates which verification detail could
        # be shared while updating the regulated order. Valid value: `prescriptionDetail`.
        attribute(:verification_detail_type, String, from: "VerificationDetailType")

        # @return [Array<VerificationStatus>] A list of valid verification statuses where the associated verification
        # detail type may be provided. For example, if the value of this field is ["Approved"], calls to provide the
        # associated verification detail will fail for orders with a `VerificationStatus` of `Pending`, `Rejected`,
        # `Expired`, or `Cancelled`.
        attribute(:valid_verification_statuses, Array, from: "ValidVerificationStatuses")
      end
    end
  end
end
