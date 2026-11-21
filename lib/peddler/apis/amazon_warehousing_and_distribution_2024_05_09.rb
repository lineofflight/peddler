# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Amazon Warehousing and Distribution
    #
    # The Selling Partner API for Amazon Warehousing and Distribution (AWD) provides programmatic access to information
    # about AWD shipments and inventory.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/amazon-warehousing-and-distribution-model/awd_2024-05-09.json
    module AmazonWarehousingAndDistribution20240509
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "amazon_warehousing_and_distribution_2024_05_09.check_inbound_eligibility" => -> { InboundEligibility },
        "amazon_warehousing_and_distribution_2024_05_09.create_inbound" => -> { InboundOrderReference },
        "amazon_warehousing_and_distribution_2024_05_09.create_outbound" => -> { OutboundOrderReference },
        "amazon_warehousing_and_distribution_2024_05_09.create_replenishment_order" => -> { ReplenishmentOrderReference },
        "amazon_warehousing_and_distribution_2024_05_09.get_inbound" => -> { InboundOrder },
        "amazon_warehousing_and_distribution_2024_05_09.get_inbound_shipment" => -> { InboundShipment },
        "amazon_warehousing_and_distribution_2024_05_09.get_inbound_shipment_labels" => -> { ShipmentLabels },
        "amazon_warehousing_and_distribution_2024_05_09.get_label_page_types" => -> { ShipmentLabelPageTypes },
        "amazon_warehousing_and_distribution_2024_05_09.get_outbound" => -> { OutboundOrder },
        "amazon_warehousing_and_distribution_2024_05_09.get_replenishment_order" => -> { ReplenishmentOrder },
        "amazon_warehousing_and_distribution_2024_05_09.list_inbound_shipments" => -> { ShipmentListing },
        "amazon_warehousing_and_distribution_2024_05_09.list_inventory" => -> { InventoryListing },
        "amazon_warehousing_and_distribution_2024_05_09.list_outbounds" => -> { OutboundListing },
        "amazon_warehousing_and_distribution_2024_05_09.list_replenishment_orders" => -> { ReplenishmentOrderListing },
        "amazon_warehousing_and_distribution_2024_05_09.update_outbound" => -> { OutboundOrderReference },
      })
    end
  end
end
