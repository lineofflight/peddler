# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # All necessary compliance attributes specific to the line item.
      ComplianceAttributes = Structure.new do
        # @return [String] Whether the country of origin must be provided for this line item.
        attribute(:country_of_origin_requirement, String, null: false, from: "countryOfOriginRequirement")

        # @return [String] Whether hazardous material labels must be applied on packages containing this line item.
        attribute(:hazmat_labels_requirement, String, null: false, from: "hazmatLabelsRequirement")

        # @return [String] Whether the item value must be provided for this line item.
        attribute(:item_value_requirement, String, null: false, from: "itemValueRequirement")

        # @return [String] Whether serial numbers must be provided for this line item.
        attribute(:serial_number_requirement, String, null: false, from: "serialNumberRequirement")
      end
    end
  end
end
