# frozen_string_literal: true

require "helper"
require "peddler/apis/fulfillment_inbound_2024_03_20"

module Peddler
  module APIs
    class FulfillmentInbound20240320Test < Minitest::Test
      include FeatureHelpers

      def test_list_inbound_plans
        res = api.sandbox.list_inbound_plans(status: "ACTIVE", sort_by: "LAST_UPDATED_TIME", sort_order: "ASC", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_create_inbound_plan
        res = api.sandbox.create_inbound_plan({ "name" => "FBA (03/20/2024, 12:01 PM)", "sourceAddress" => { "name" => "name", "companyName" => "Acme", "addressLine1" => "123 example street", "addressLine2" => "Unit 102", "city" => "Toronto", "countryCode" => "CA", "stateOrProvinceCode" => "ON", "postalCode" => "M1M1M1", "phoneNumber" => "1234567890", "email" => "email@email.com" }, "destinationMarketplaces" => ["A2EUQ1WTGCTBG2"], "items" => [{ "msku" => "msku", "prepOwner" => "AMAZON", "labelOwner" => "AMAZON", "quantity" => 2, "expiration" => "2024-01-01", "manufacturingLotCode" => "lotCode" }] })

        assert_predicate(res.status, :success?)
      end

      def test_get_inbound_plan
        res = api.sandbox.get_inbound_plan("wf1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_list_inbound_plan_boxes
        res = api.sandbox.list_inbound_plan_boxes("wf1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_cancel_inbound_plan
        res = api.sandbox.cancel_inbound_plan("wf1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_list_inbound_plan_items
        res = api.sandbox.list_inbound_plan_items("wf1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_update_inbound_plan_name
        res = api.sandbox.update_inbound_plan_name("wf1234abcd-1234-abcd-5678-1234abcd5678", { "name" => "updatedInboundPlanName" })

        assert_predicate(res.status, :success?)
      end

      def test_list_packing_group_boxes
        res = api.sandbox.list_packing_group_boxes("wf1234abcd-1234-abcd-5678-1234abcd5678", "pg1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_list_packing_group_items
        res = api.sandbox.list_packing_group_items("wf1234abcd-1234-abcd-5678-1234abcd5678", "pg1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_list_packing_options
        res = api.sandbox.list_packing_options("wf1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_generate_packing_options
        res = api.sandbox.generate_packing_options("wf1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_confirm_packing_option
        res = api.sandbox.confirm_packing_option("wf1234abcd-1234-abcd-5678-1234abcd5678", "po1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_list_inbound_plan_pallets
        res = api.sandbox.list_inbound_plan_pallets("wf1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_list_placement_options
        res = api.sandbox.list_placement_options("wf1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_generate_placement_options
        res = api.sandbox.generate_placement_options("wf1234abcd-1234-abcd-5678-1234abcd5678", { "customPlacement" => [{ "warehouseId" => "warehouseId", "items" => [{ "msku" => "msku", "prepOwner" => "AMAZON", "labelOwner" => "AMAZON", "quantity" => 2, "expiration" => "2024-01-01", "manufacturingLotCode" => "lotCode" }] }] })

        assert_predicate(res.status, :success?)
      end

      def test_confirm_placement_option
        res = api.sandbox.confirm_placement_option("wf1234abcd-1234-abcd-5678-1234abcd5678", "pl1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_get_shipment
        res = api.sandbox.get_shipment("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_list_shipment_boxes
        res = api.sandbox.list_shipment_boxes("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_list_shipment_content_update_previews
        res = api.sandbox.list_shipment_content_update_previews("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_get_shipment_content_update_preview
        res = api.sandbox.get_shipment_content_update_preview("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", "cu1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_confirm_shipment_content_update_preview
        res = api.sandbox.confirm_shipment_content_update_preview("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", "cu1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_get_delivery_challan_document
        res = api.sandbox.get_delivery_challan_document("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_list_delivery_window_options
        res = api.sandbox.list_delivery_window_options("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_generate_delivery_window_options
        res = api.sandbox.generate_delivery_window_options("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_confirm_delivery_window_options
        res = api.sandbox.confirm_delivery_window_options("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", "dw1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end

      def test_list_shipment_items
        res = api.sandbox.list_shipment_items("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_update_shipment_name
        res = api.sandbox.update_shipment_name("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", { "name" => "updatedShipmentName" })

        assert_predicate(res.status, :success?)
      end

      def test_list_shipment_pallets
        res = api.sandbox.list_shipment_pallets("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_cancel_self_ship_appointment
        res = api.sandbox.cancel_self_ship_appointment("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", { "reasonComment" => "OTHER" })

        assert_predicate(res.status, :success?)
      end

      def test_get_self_ship_appointment_slots
        res = api.sandbox.get_self_ship_appointment_slots("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_generate_self_ship_appointment_slots
        res = api.sandbox.generate_self_ship_appointment_slots("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", { "desiredEndDate" => "2024-01-15T00:00:00.000Z", "desiredStartDate" => "2024-01-16T00:00:00.000Z" })

        assert_predicate(res.status, :success?)
      end

      def test_schedule_self_ship_appointment
        res = api.sandbox.schedule_self_ship_appointment("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", "aa1234abcd-1234-abcd-5678-1234abcd5678", { "reasonComment" => "OTHER" })

        assert_predicate(res.status, :success?)
      end

      def test_update_shipment_source_address
        res = api.sandbox.update_shipment_source_address("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", { "address" => { "name" => "name", "companyName" => "Acme", "addressLine1" => "123 example street", "addressLine2" => "Unit 102", "city" => "Toronto", "countryCode" => "CA", "stateOrProvinceCode" => "ON", "postalCode" => "M1M1M1", "phoneNumber" => "1234567890", "email" => "email@email.com" } })

        assert_predicate(res.status, :success?)
      end

      def test_update_shipment_tracking_details
        res = api.sandbox.update_shipment_tracking_details("wf1234abcd-1234-abcd-5678-1234abcd5678", "sh1234abcd-1234-abcd-5678-1234abcd5678", { "trackingDetails" => { "ltlTrackingDetail" => { "freightBillNumber" => ["freightBillNumber1"], "billOfLadingNumber" => "billOfLadingNumber" }, "spdTrackingDetail" => { "spdTrackingItems" => [{ "boxId" => "boxId", "trackingId" => "trackingId" }] } } })

        assert_predicate(res.status, :success?)
      end

      def test_list_transportation_options
        res = api.sandbox.list_transportation_options("wf1234abcd-1234-abcd-5678-1234abcd5678", placement_option_id: "pl1234abcd-1234-abcd-5678-1234abcd5678", shipment_id: "sh1234abcd-1234-abcd-5678-1234abcd5678", page_size: 2, pagination_token: "paginationToken")

        assert_predicate(res.status, :success?)
      end

      def test_confirm_transportation_options
        res = api.sandbox.confirm_transportation_options("wf1234abcd-1234-abcd-5678-1234abcd5678", { "transportationSelections" => [{ "shipmentId" => "sh1234abcd-1234-abcd-5678-1234abcd5678", "transportationOptionId" => "to1234abcd-1234-abcd-5678-1234abcd5678", "contactInformation" => { "name" => "name", "phoneNumber" => "1234567890", "email" => "email@email.com" } }] })

        assert_predicate(res.status, :success?)
      end

      def test_list_item_compliance_details
        res = api.sandbox.list_item_compliance_details(["msku1", "msku2"], "ATVPDKIKX0DER")

        assert_predicate(res.status, :success?)
      end

      def test_create_marketplace_item_labels
        res = api.sandbox.create_marketplace_item_labels({ "marketplaceId" => "ATVPDKIKX0DER", "mskuQuantities" => [{ "msku" => "msku1", "quantity" => 1 }, { "msku" => "msku2", "quantity" => 1 }], "labelType" => "STANDARD_FORMAT", "pageType" => "A4_21", "localeCode" => "en_US" })

        assert_predicate(res.status, :success?)
      end

      def test_list_prep_details
        res = api.sandbox.list_prep_details("ATVPDKIKX0DER", ["msku1", "msku2"])

        assert_predicate(res.status, :success?)
      end

      def test_set_prep_details
        res = api.sandbox.set_prep_details({ "marketplaceId" => "ATVPDKIKX0DER", "mskuPrepDetails" => [{ "msku" => "msku", "prepCategory" => "TEXTILE", "prepTypes" => ["ITEM_LABELING", "ITEM_POLYBAGGING"] }] })

        assert_predicate(res.status, :success?)
      end

      def test_get_inbound_operation_status
        res = api.sandbox.get_inbound_operation_status("1234abcd-1234-abcd-5678-1234abcd5678")

        assert_predicate(res.status, :success?)
      end
    end
  end
end
