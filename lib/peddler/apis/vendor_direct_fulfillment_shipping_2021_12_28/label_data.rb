# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShipping20211228
      # Details of the shipment label.
      LabelData = Structure.new do
        # @return [String] This field will contain the Base64 string of the shipment label content.
        attribute(:content, String)

        # @return [String] Identifier for the package. The first package will be 001, the second 002, and so on. This
        #   number is used as a reference to refer to this package from the pallet level.
        attribute?(:package_identifier, String, from: "packageIdentifier")

        # @return [String] Ship method to be used for shipping the order. Amazon defines Ship Method Codes indicating
        #   shipping carrier and shipment service level. Ship Method Codes are case and format sensitive. The same ship
        #   method code should returned on the shipment confirmation. Note that the Ship Method Codes are vendor
        #   specific and will be provided to each vendor during the implementation.
        attribute?(:ship_method, String, from: "shipMethod")

        # @return [String] Shipping method name for internal reference.
        attribute?(:ship_method_name, String, from: "shipMethodName")

        # @return [String] Package tracking identifier from the shipping carrier.
        attribute?(:tracking_number, String, from: "trackingNumber")
      end
    end
  end
end
