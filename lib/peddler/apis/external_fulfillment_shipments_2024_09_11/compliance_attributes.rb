# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # All necessary compliance attributes specific to the line item.
      ComplianceAttributes = Structure.new do
        # @return [String] Whether hazardous material labels must be applied on packages containing this line item.
        #   Known values: `REQUIRED`, `DISALLOWED`.
        attribute(:hazmat_labels_requirement, String, null: false, from: "hazmatLabelsRequirement")

        # @return [String] Whether serial numbers must be provided for this line item. Known values: `REQUIRED`,
        #   `DISALLOWED`.
        attribute(:serial_number_requirement, String, null: false, from: "serialNumberRequirement")

        # @return [String] Whether the country of origin must be provided for this line item. Known values: `REQUIRED`,
        #   `DISALLOWED`.
        attribute?(:country_of_origin_requirement, String, from: "countryOfOriginRequirement")

        # @return [String] Whether a hazardous material label must be applied on packages containing this line item.
        #   Known values: `REQUIRED`, `DISALLOWED`.
        attribute?(:hazmat_label_requirement, String, from: "hazmatLabelRequirement")

        # @return [String] Whether the item value must be provided for this line item. Known values: `REQUIRED`,
        #   `DISALLOWED`.
        attribute?(:item_value_requirement, String, from: "itemValueRequirement")
      end
    end
  end
end
