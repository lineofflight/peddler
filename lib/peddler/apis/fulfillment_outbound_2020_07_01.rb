# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner APIs for Fulfillment Outbound
    #
    # The Selling Partner API for Fulfillment Outbound lets you create applications that help a seller fulfill
    # Multi-Channel Fulfillment orders using their inventory in Amazon's fulfillment network. You can get information on
    # both potential and existing fulfillment orders.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/fulfillment-outbound-api-model/fulfillmentOutbound_2020-07-01.json
    module FulfillmentOutbound20200701
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "fulfillment_outbound_2020_07_01.cancel_fulfillment_order" => -> { CancelFulfillmentOrderResponse },
        "fulfillment_outbound_2020_07_01.create_fulfillment_order" => -> { CreateFulfillmentOrderResponse },
        "fulfillment_outbound_2020_07_01.create_fulfillment_return" => -> { CreateFulfillmentReturnResponse },
        "fulfillment_outbound_2020_07_01.delivery_offers" => -> { GetDeliveryOffersResponse },
        "fulfillment_outbound_2020_07_01.get_feature_inventory" => -> { GetFeatureInventoryResponse },
        "fulfillment_outbound_2020_07_01.get_feature_sku" => -> { GetFeatureSKUResponse },
        "fulfillment_outbound_2020_07_01.get_features" => -> { GetFeaturesResponse },
        "fulfillment_outbound_2020_07_01.get_fulfillment_order" => -> { GetFulfillmentOrderResponse },
        "fulfillment_outbound_2020_07_01.get_fulfillment_preview" => -> { GetFulfillmentPreviewResponse },
        "fulfillment_outbound_2020_07_01.get_package_tracking_details" => -> { GetPackageTrackingDetailsResponse },
        "fulfillment_outbound_2020_07_01.list_all_fulfillment_orders" => -> { ListAllFulfillmentOrdersResponse },
        "fulfillment_outbound_2020_07_01.list_return_reason_codes" => -> { ListReturnReasonCodesResponse },
        "fulfillment_outbound_2020_07_01.submit_fulfillment_order_status_update" => -> { SubmitFulfillmentOrderStatusUpdateResponse },
        "fulfillment_outbound_2020_07_01.update_fulfillment_order" => -> { UpdateFulfillmentOrderResponse },
      })
    end
  end
end
