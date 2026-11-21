# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The details of a shipping service offering.
      Rate = Structure.new do
        attribute(:carrier_id, String, null: false, from: "carrierId")

        attribute(:carrier_name, String, null: false, from: "carrierName")

        attribute(:promise, Promise, null: false)

        attribute(:rate_id, String, null: false, from: "rateId")

        # When true, indicates that additional inputs are required to purchase this shipment service. You must then call
        # the getAdditionalInputs operation to return the JSON schema to use when providing the additional inputs to the
        # purchaseShipment operation.
        attribute(:requires_additional_inputs, :boolean, null: false, from: "requiresAdditionalInputs")

        attribute(:service_id, String, null: false, from: "serviceId")

        attribute(:service_name, String, null: false, from: "serviceName")

        attribute(:supported_document_specifications, [SupportedDocumentSpecification], null: false, from: "supportedDocumentSpecifications")

        attribute(:total_charge, Money, null: false, from: "totalCharge")

        attribute?(:available_value_added_service_groups, [AvailableValueAddedServiceGroup], from: "availableValueAddedServiceGroups")

        attribute?(:benefits, Benefits)

        attribute?(:billed_weight, Weight, from: "billedWeight")

        # Known values: `PAY_THROUGH_AMAZON`, `PAY_DIRECT_TO_CARRIER`.
        attribute?(:payment_type, String, from: "paymentType")

        attribute?(:rate_item_list, [RateItem], from: "rateItemList")
      end
    end
  end
end
