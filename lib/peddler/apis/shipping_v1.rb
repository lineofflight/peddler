# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Shipping
    #
    # Provides programmatic access to Amazon Shipping APIs.
    #
    # **Note:** If you are new to the Amazon Shipping API, refer to the latest version of
    # {https://developer-docs.amazon.com/amazon-shipping/docs/shipping-api-v2-reference Amazon Shipping API (v2)} on the
    # {https://developer-docs.amazon.com/amazon-shipping/ Amazon Shipping Developer Documentation} site.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/shipping-api-model/shipping.json
    module ShippingV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "shipping_v1.cancel_shipment" => -> { CancelShipmentResponse },
        "shipping_v1.create_shipment" => -> { CreateShipmentResponse },
        "shipping_v1.get_account" => -> { GetAccountResponse },
        "shipping_v1.get_rates" => -> { GetRatesResponse },
        "shipping_v1.get_shipment" => -> { GetShipmentResponse },
        "shipping_v1.get_tracking_information" => -> { GetTrackingInformationResponse },
        "shipping_v1.purchase_labels" => -> { PurchaseLabelsResponse },
        "shipping_v1.purchase_shipment" => -> { PurchaseShipmentResponse },
        "shipping_v1.retrieve_shipping_label" => -> { RetrieveShippingLabelResponse },
      })
    end
  end
end
