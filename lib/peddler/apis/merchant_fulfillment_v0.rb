# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Merchant Fulfillment
    #
    # With the Selling Partner API for Merchant Fulfillment, you can build applications that sellers can use to purchase
    # shipping for non-Prime and Prime orders using Amazon's Buy Shipping Services.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/merchant-fulfillment-api-model/merchantFulfillmentV0.json
    module MerchantFulfillmentV0
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "merchant_fulfillment_v0.cancel_shipment" => -> { CancelShipmentResponse },
        "merchant_fulfillment_v0.create_shipment" => -> { CreateShipmentResponse },
        "merchant_fulfillment_v0.get_additional_seller_inputs" => -> { GetAdditionalSellerInputsResponse },
        "merchant_fulfillment_v0.get_eligible_shipment_services" => -> { GetEligibleShipmentServicesResponse },
        "merchant_fulfillment_v0.get_shipment" => -> { GetShipmentResponse },
      })
    end
  end
end
