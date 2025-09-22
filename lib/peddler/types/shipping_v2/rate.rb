# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/shipping_v2/weight"
require "peddler/types/shipping_v2/promise"
require "peddler/types/shipping_v2/supported_document_specification"
require "peddler/types/shipping_v2/available_value_added_service_group"
require "peddler/types/shipping_v2/rate_item"
require "peddler/types/shipping_v2/benefits"

module Peddler
  module Types
    module ShippingV2
      # The details of a shipping service offering.
      Rate = Structure.new do
        # @return [String]
        attribute(:rate_id, String, from: "rateId")

        # @return [String]
        attribute(:carrier_id, String, from: "carrierId")

        # @return [String]
        attribute(:carrier_name, String, from: "carrierName")

        # @return [String]
        attribute(:service_id, String, from: "serviceId")

        # @return [String]
        attribute(:service_name, String, from: "serviceName")

        # @return [Weight]
        attribute(:billed_weight, Weight, from: "billedWeight")

        # @return [Types::Money]
        attribute(:total_charge, Types::Money, from: "totalCharge")

        # @return [Promise]
        attribute(:promise, Promise)

        # @return [Array<SupportedDocumentSpecification>]
        attribute(:supported_document_specifications, [SupportedDocumentSpecification], from: "supportedDocumentSpecifications")

        # @return [Array<AvailableValueAddedServiceGroup>]
        attribute(:available_value_added_service_groups, [AvailableValueAddedServiceGroup], from: "availableValueAddedServiceGroups")

        # @return [:boolean] When true, indicates that additional inputs are required to purchase this shipment service.
        # You must then call the getAdditionalInputs operation to return the JSON schema to use when providing the
        # additional inputs to the purchaseShipment operation.
        attribute(:requires_additional_inputs, :boolean, from: "requiresAdditionalInputs")

        # @return [Array<RateItem>]
        attribute(:rate_item_list, [RateItem], from: "rateItemList")

        # @return [String]
        attribute(:payment_type, String, from: "paymentType")

        # @return [Benefits]
        attribute(:benefits, Benefits)
      end
    end
  end
end
