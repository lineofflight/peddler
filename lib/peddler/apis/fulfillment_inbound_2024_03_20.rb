# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for FBA inbound operations.
    #
    # The Selling Partner API for Fulfillment By Amazon (FBA) Inbound. The FBA Inbound API enables building inbound
    # workflows to create, manage, and send shipments into Amazon's fulfillment network. The API has interoperability
    # with the Send-to-Amazon user interface.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/fulfillment-inbound-api-model/fulfillmentInbound_2024-03-20.json
    module FulfillmentInbound20240320
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "fulfillment_inbound_2024_03_20.cancel_inbound_plan" => -> { CancelInboundPlanResponse },
        "fulfillment_inbound_2024_03_20.cancel_self_ship_appointment" => -> { CancelSelfShipAppointmentResponse },
        "fulfillment_inbound_2024_03_20.confirm_delivery_window_options" => -> { ConfirmDeliveryWindowOptionsResponse },
        "fulfillment_inbound_2024_03_20.confirm_packing_option" => -> { ConfirmPackingOptionResponse },
        "fulfillment_inbound_2024_03_20.confirm_placement_option" => -> { ConfirmPlacementOptionResponse },
        "fulfillment_inbound_2024_03_20.confirm_shipment_content_update_preview" => -> { ConfirmShipmentContentUpdatePreviewResponse },
        "fulfillment_inbound_2024_03_20.confirm_transportation_options" => -> { ConfirmTransportationOptionsResponse },
        "fulfillment_inbound_2024_03_20.create_inbound_plan" => -> { CreateInboundPlanResponse },
        "fulfillment_inbound_2024_03_20.create_marketplace_item_labels" => -> { CreateMarketplaceItemLabelsResponse },
        "fulfillment_inbound_2024_03_20.generate_delivery_window_options" => -> { GenerateDeliveryWindowOptionsResponse },
        "fulfillment_inbound_2024_03_20.generate_packing_options" => -> { GeneratePackingOptionsResponse },
        "fulfillment_inbound_2024_03_20.generate_placement_options" => -> { GeneratePlacementOptionsResponse },
        "fulfillment_inbound_2024_03_20.generate_self_ship_appointment_slots" => -> { GenerateSelfShipAppointmentSlotsResponse },
        "fulfillment_inbound_2024_03_20.generate_shipment_content_update_previews" => -> { GenerateShipmentContentUpdatePreviewsResponse },
        "fulfillment_inbound_2024_03_20.generate_transportation_options" => -> { GenerateTransportationOptionsResponse },
        "fulfillment_inbound_2024_03_20.get_delivery_challan_document" => -> { GetDeliveryChallanDocumentResponse },
        "fulfillment_inbound_2024_03_20.get_inbound_operation_status" => -> { InboundOperationStatus },
        "fulfillment_inbound_2024_03_20.get_inbound_plan" => -> { InboundPlan },
        "fulfillment_inbound_2024_03_20.get_self_ship_appointment_slots" => -> { GetSelfShipAppointmentSlotsResponse },
        "fulfillment_inbound_2024_03_20.get_shipment" => -> { Shipment },
        "fulfillment_inbound_2024_03_20.get_shipment_content_update_preview" => -> { ContentUpdatePreview },
        "fulfillment_inbound_2024_03_20.list_delivery_window_options" => -> { ListDeliveryWindowOptionsResponse },
        "fulfillment_inbound_2024_03_20.list_inbound_plan_boxes" => -> { ListInboundPlanBoxesResponse },
        "fulfillment_inbound_2024_03_20.list_inbound_plan_items" => -> { ListInboundPlanItemsResponse },
        "fulfillment_inbound_2024_03_20.list_inbound_plan_pallets" => -> { ListInboundPlanPalletsResponse },
        "fulfillment_inbound_2024_03_20.list_inbound_plans" => -> { ListInboundPlansResponse },
        "fulfillment_inbound_2024_03_20.list_item_compliance_details" => -> { ListItemComplianceDetailsResponse },
        "fulfillment_inbound_2024_03_20.list_packing_group_boxes" => -> { ListPackingGroupBoxesResponse },
        "fulfillment_inbound_2024_03_20.list_packing_group_items" => -> { ListPackingGroupItemsResponse },
        "fulfillment_inbound_2024_03_20.list_packing_options" => -> { ListPackingOptionsResponse },
        "fulfillment_inbound_2024_03_20.list_placement_options" => -> { ListPlacementOptionsResponse },
        "fulfillment_inbound_2024_03_20.list_prep_details" => -> { ListPrepDetailsResponse },
        "fulfillment_inbound_2024_03_20.list_shipment_boxes" => -> { ListShipmentBoxesResponse },
        "fulfillment_inbound_2024_03_20.list_shipment_content_update_previews" => -> { ListShipmentContentUpdatePreviewsResponse },
        "fulfillment_inbound_2024_03_20.list_shipment_items" => -> { ListShipmentItemsResponse },
        "fulfillment_inbound_2024_03_20.list_shipment_pallets" => -> { ListShipmentPalletsResponse },
        "fulfillment_inbound_2024_03_20.list_transportation_options" => -> { ListTransportationOptionsResponse },
        "fulfillment_inbound_2024_03_20.schedule_self_ship_appointment" => -> { ScheduleSelfShipAppointmentResponse },
        "fulfillment_inbound_2024_03_20.set_packing_information" => -> { SetPackingInformationResponse },
        "fulfillment_inbound_2024_03_20.set_prep_details" => -> { SetPrepDetailsResponse },
        "fulfillment_inbound_2024_03_20.update_item_compliance_details" => -> { UpdateItemComplianceDetailsResponse },
        "fulfillment_inbound_2024_03_20.update_shipment_source_address" => -> { UpdateShipmentSourceAddressResponse },
        "fulfillment_inbound_2024_03_20.update_shipment_tracking_details" => -> { UpdateShipmentTrackingDetailsResponse },
      }.freeze
    end
  end
end
