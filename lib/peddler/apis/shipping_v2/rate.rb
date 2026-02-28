# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The details of a shipping service offering.
      Rate = Structure.new do
        # @return [String]
        attribute(:carrier_id, String, null: false, from: "carrierId")

        # @return [String]
        attribute(:carrier_name, String, null: false, from: "carrierName")

        # @return [Promise]
        attribute(:promise, Promise, null: false)

        # @return [String]
        attribute(:rate_id, String, null: false, from: "rateId")

        # @return [:boolean] When true, indicates that additional inputs are required to purchase this shipment service.
        #   You must then call the getAdditionalInputs operation to return the JSON schema to use when providing the
        #   additional inputs to the purchaseShipment operation.
        attribute(:requires_additional_inputs, :boolean, null: false, from: "requiresAdditionalInputs")

        # @return [String]
        attribute(:service_id, String, null: false, from: "serviceId")

        # @return [String]
        attribute(:service_name, String, null: false, from: "serviceName")

        # @return [Array<SupportedDocumentSpecification>]
        attribute(:supported_document_specifications, [SupportedDocumentSpecification], null: false, from: "supportedDocumentSpecifications")

        # @return [Money]
        attribute(:total_charge, Money, null: false, from: "totalCharge")

        # @return [Array<AvailableValueAddedServiceGroup>]
        attribute?(:available_value_added_service_groups, [AvailableValueAddedServiceGroup], from: "availableValueAddedServiceGroups")

        # @return [Benefits]
        attribute?(:benefits, Benefits)

        # @return [Weight]
        attribute?(:billed_weight, Weight, from: "billedWeight")

        # @return [String]
        attribute?(:payment_type, String, from: "paymentType")

        # @return [Array<RateItem>]
        attribute?(:rate_item_list, [RateItem], from: "rateItemList")
      end
    end
  end
end
