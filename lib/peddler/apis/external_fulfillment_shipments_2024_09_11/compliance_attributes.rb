# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # All necessary compliance attributes specific to the line item.
      ComplianceAttributes = Structure.new do
        # Whether the country of origin must be provided for this line item. Known values: `REQUIRED`, `DISALLOWED`.
        attribute(:country_of_origin_requirement, String, null: false, from: "countryOfOriginRequirement")

        # Whether hazardous material labels must be applied on packages containing this line item. Known values:
        # `REQUIRED`, `DISALLOWED`.
        attribute(:hazmat_labels_requirement, String, null: false, from: "hazmatLabelsRequirement")

        # Whether the item value must be provided for this line item. Known values: `REQUIRED`, `DISALLOWED`.
        attribute(:item_value_requirement, String, null: false, from: "itemValueRequirement")

        # Whether serial numbers must be provided for this line item. Known values: `REQUIRED`, `DISALLOWED`.
        attribute(:serial_number_requirement, String, null: false, from: "serialNumberRequirement")
      end
    end
  end
end
