# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Amazon Shipping API
    #
    # The Amazon Shipping API is designed to support outbound shipping use cases both for orders originating on
    # Amazon-owned marketplaces as well as external channels/marketplaces. With these APIs, you can request shipping
    # rates, create shipments, cancel shipments, and track shipments.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/shipping-api-model/shippingV2.json
    module ShippingV2
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "shipping_v2.cancel_shipment" => -> { CancelShipmentResponse },
        "shipping_v2.create_claim" => -> { CreateClaimResponse },
        "shipping_v2.direct_purchase_shipment" => -> { DirectPurchaseResponse },
        "shipping_v2.generate_collection_form" => -> { GenerateCollectionFormResponse },
        "shipping_v2.get_access_points" => -> { GetAccessPointsResponse },
        "shipping_v2.get_additional_inputs" => -> { GetAdditionalInputsResponse },
        "shipping_v2.get_carrier_account_form_inputs" => -> { GetCarrierAccountFormInputsResponse },
        "shipping_v2.get_carrier_accounts" => -> { GetCarrierAccountsResponse },
        "shipping_v2.get_collection_form" => -> { GetCollectionFormResponse },
        "shipping_v2.get_collection_form_history" => -> { GetCollectionFormHistoryResponse },
        "shipping_v2.get_rates" => -> { GetRatesResponse },
        "shipping_v2.get_shipment_documents" => -> { GetShipmentDocumentsResponse },
        "shipping_v2.get_tracking" => -> { GetTrackingResponse },
        "shipping_v2.get_unmanifested_shipments" => -> { GetUnmanifestedShipmentsResponse },
        "shipping_v2.link_carrier_account" => -> { LinkCarrierAccountResponse },
        "shipping_v2.link_carrier_account_put" => -> { LinkCarrierAccountResponse },
        "shipping_v2.one_click_shipment" => -> { OneClickShipmentResponse },
        "shipping_v2.purchase_shipment" => -> { PurchaseShipmentResponse },
        "shipping_v2.unlink_carrier_account" => -> { UnlinkCarrierAccountResponse },
      })
    end
  end
end
