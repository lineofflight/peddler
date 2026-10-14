# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Rate Item for shipping (base cost, transaction fee, confirmation, insurance, etc.) Data source definition:
      RateItem = Structure.new do
        # @return [Money]
        attribute?(:rate_item_charge, Money, from: "rateItemCharge")

        # @return [String] Known values: `BASE_RATE`, `TRANSACTION_FEE`, `ADULT_SIGNATURE_CONFIRMATION`,
        #   `SIGNATURE_CONFIRMATION`, `NO_CONFIRMATION`, `WAIVE_SIGNATURE`, `IMPLIED_LIABILITY`, `HIDDEN_POSTAGE`,
        #   `DECLARED_VALUE`, `SUNDAY_HOLIDAY_DELIVERY`, `DELIVERY_CONFIRMATION`, `IMPORT_DUTY_CHARGE`, `VAT`,
        #   `NO_SATURDAY_DELIVERY`, `INSURANCE`, `COD`, `FUEL_SURCHARGE`, `INSPECTION_CHARGE`,
        #   `DELIVERY_AREA_SURCHARGE`, `WAYBILL_CHARGE`, `AMAZON_SPONSORED_DISCOUNT`, `INTEGRATOR_SPONSORED_DISCOUNT`,
        #   `OVERSIZE_SURCHARGE`, `CONGESTION_CHARGE`, `RESIDENTIAL_SURCHARGE`, `ADDITIONAL_SURCHARGE`, `SURCHARGE`,
        #   `REBATE`, `HIGH_CUBE_SURCHARGE`, `HIGH_LENGTH_SURCHARGE`, `HIGH_WIDTH_SURCHARGE`, `DEMAND_SURCHARGE`,
        #   `NONSTANDARD_FEE`.
        attribute?(:rate_item_id, String, from: "rateItemID")

        # @return [String] Used for the localization.
        attribute?(:rate_item_name_localization, String, from: "rateItemNameLocalization")

        # @return [String] Known values: `MANDATORY`, `OPTIONAL`, `INCLUDED`.
        attribute?(:rate_item_type, String, from: "rateItemType")
      end
    end
  end
end
