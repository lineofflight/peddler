# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # The dimensions of a package contained in a shipment.
      PackageDimensions = Structure.new do
        # @return [Float] The height dimension. If you don't specify `PredefinedPackageDimensions`, you must specify the
        #   height.
        attribute?(:height, Float, from: "Height")

        # @return [Float] The length dimension. If you don't specify `PredefinedPackageDimensions`, you must specify the
        #   length.
        attribute?(:length, Float, from: "Length")

        # @return [String] Known values: `FedEx_Box_10kg`, `FedEx_Box_25kg`, `FedEx_Box_Extra_Large_1`,
        #   `FedEx_Box_Extra_Large_2`, `FedEx_Box_Large_1`, `FedEx_Box_Large_2`, `FedEx_Box_Medium_1`,
        #   `FedEx_Box_Medium_2`, `FedEx_Box_Small_1`, `FedEx_Box_Small_2`, `FedEx_Envelope`, `FedEx_Padded_Pak`,
        #   `FedEx_Pak_1`, `FedEx_Pak_2`, `FedEx_Tube`, `FedEx_XL_Pak`, `UPS_Box_10kg`, `UPS_Box_25kg`,
        #   `UPS_Express_Box`, `UPS_Express_Box_Large`, `UPS_Express_Box_Medium`, `UPS_Express_Box_Small`,
        #   `UPS_Express_Envelope`, `UPS_Express_Hard_Pak`, `UPS_Express_Legal_Envelope`, `UPS_Express_Pak`,
        #   `UPS_Express_Tube`, `UPS_Laboratory_Pak`, `UPS_Pad_Pak`, `UPS_Pallet`, `USPS_Card`, `USPS_Flat`,
        #   `USPS_FlatRateCardboardEnvelope`, `USPS_FlatRateEnvelope`, `USPS_FlatRateGiftCardEnvelope`,
        #   `USPS_FlatRateLegalEnvelope`, `USPS_FlatRatePaddedEnvelope`, `USPS_FlatRateWindowEnvelope`,
        #   `USPS_LargeFlatRateBoardGameBox`, `USPS_LargeFlatRateBox`, `USPS_Letter`, `USPS_MediumFlatRateBox1`,
        #   `USPS_MediumFlatRateBox2`, `USPS_RegionalRateBoxA1`, `USPS_RegionalRateBoxA2`, `USPS_RegionalRateBoxB1`,
        #   `USPS_RegionalRateBoxB2`, `USPS_RegionalRateBoxC`, `USPS_SmallFlatRateBox`, `USPS_SmallFlatRateEnvelope`.
        attribute?(:predefined_package_dimensions, String, from: "PredefinedPackageDimensions")

        # @return [String] The unit of measurement. If you don't specify `PredefinedPackageDimensions`, you must specify
        #   the unit. Known values: `inches`, `centimeters`.
        attribute?(:unit, String, from: "Unit")

        # @return [Float] The width dimension. If you don't specify `PredefinedPackageDimensions`, you must specify the
        #   width.
        attribute?(:width, Float, from: "Width")
      end
    end
  end
end
