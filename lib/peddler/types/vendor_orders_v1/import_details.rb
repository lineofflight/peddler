# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorOrdersV1
      # Import details for an import order.
      ImportDetails = Structure.new do
        # @return [String] If the recipient requests, contains the shipment method of payment. This is for import PO's
        # only.
        attribute(:method_of_payment, String, from: "methodOfPayment")

        # @return [String] Incoterms (International Commercial Terms) are used to divide transaction costs and
        # responsibilities between buyer and seller and reflect state-of-the-art transportation practices. This is for
        # import purchase orders only.
        attribute(:international_commercial_terms, String, from: "internationalCommercialTerms")

        # @return [String] The port where goods on an import purchase order must be delivered by the vendor. This should
        # only be specified when the internationalCommercialTerms is FOB.
        attribute(:port_of_delivery, String, from: "portOfDelivery")

        # @return [String] Types and numbers of container(s) for import purchase orders. Can be a comma-separated list
        # if the shipment has multiple containers. HC signifies a high-capacity container. Free-text field, limited to
        # 64 characters. The format will be a comma-delimited list containing values of the type:
        # $NUMBER_OF_CONTAINERS_OF_THIS_TYPE-$CONTAINER_TYPE. The list of values for the container type is: 40'(40-foot
        # container), 40'HC (40-foot high-capacity container), 45', 45'HC, 30', 30'HC, 20', 20'HC.
        attribute(:import_containers, String, from: "importContainers")

        # @return [String] Special instructions regarding the shipment. This field is for import purchase orders.
        attribute(:shipping_instructions, String, from: "shippingInstructions")
      end
    end
  end
end
