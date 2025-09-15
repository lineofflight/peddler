# frozen_string_literal: true

require "helper"
require "peddler/types/orders_v0"
require "peddler/types/catalog_items_2022_04_01"
require "peddler/types/feeds_2021_06_30"
require "peddler/types/finances_v0"

module Peddler
  class TypesIntegrationTest < Minitest::Test
    def test_orders_response_parsing
      result = parse_orders_response

      assert_instance_of(Types::OrdersV0::GetOrdersResponse, result)
      assert_instance_of(Types::OrdersV0::OrdersList, result.payload)
      assert_equal(1, result.payload.orders.length)
    end

    def test_order_structure_fields
      result = parse_orders_response
      order = result.payload.orders.first

      assert_instance_of(Types::OrdersV0::Order, order)
      assert_equal("123-4567890-1234567", order.amazon_order_id)
      assert_equal("Shipped", order.order_status)
    end

    def test_order_boolean_fields
      result = parse_orders_response
      order = result.payload.orders.first

      assert_predicate(order, :prime?)
      refute_predicate(order, :business_order?)
      refute_predicate(order, :replacement_order?)
    end

    def test_money_type_coercion
      result = parse_orders_response
      order = result.payload.orders.first

      assert_instance_of(::Money, order.order_total)
      assert_equal(9999, order.order_total.cents)
      assert_equal("USD", order.order_total.currency.iso_code)
    end

    def test_feeds_response_structure
      result = parse_feeds_response

      assert_instance_of(Types::Feeds20210630::GetFeedsResponse, result)
      assert_equal(1, result.feeds.length)
      assert_instance_of(Types::Feeds20210630::Feed, result.feeds.first)
    end

    def test_feeds_datetime_as_string
      result = parse_feeds_response
      feed = result.feeds.first

      assert_instance_of(String, feed.created_time)
      assert_equal("2024-01-15T14:30:00.000Z", feed.created_time)
    end

    def test_finances_response_hierarchy
      result = parse_finances_response

      assert_instance_of(Types::FinancesV0::ListFinancialEventsResponse, result)
      assert_instance_of(Types::FinancesV0::FinancialEvents, result.payload.financial_events)
      assert_instance_of(Types::FinancesV0::ShipmentEvent, result.payload.financial_events.shipment_event_list.first)
    end

    def test_finances_shipment_items
      result = parse_finances_response
      shipment = result.payload.financial_events.shipment_event_list.first
      item = shipment.shipment_item_list.first

      assert_instance_of(Types::FinancesV0::ShipmentItem, item)
      assert_equal("SKU123", item.seller_sku)
      assert_equal(1, item.quantity_shipped)
    end

    def test_finances_currency_type
      result = parse_finances_response
      shipment = result.payload.financial_events.shipment_event_list.first
      charge = shipment.shipment_item_list.first.item_charge_list.first

      assert_instance_of(Types::FinancesV0::Currency, charge.charge_amount)
      assert_equal("EUR", charge.charge_amount.currency_code)
      assert_equal(BigDecimal("49.99"), charge.charge_amount.currency_amount)
    end

    def test_catalog_items_search_results
      result = parse_catalog_items_response

      assert_instance_of(Types::CatalogItems20220401::ItemSearchResults, result)
      assert_equal(2, result.number_of_results)
      assert_equal(2, result.items.length)
    end

    def test_catalog_item_structure
      result = parse_catalog_items_response
      first_item = result.items.first

      assert_instance_of(Types::CatalogItems20220401::Item, first_item)
      assert_equal("B001234567", first_item.asin)
    end

    def test_catalog_item_identifiers
      result = parse_catalog_items_response
      marketplace_identifiers = result.items.first.identifiers.first

      assert_instance_of(Types::CatalogItems20220401::ItemIdentifiersByMarketplace, marketplace_identifiers)
      assert_equal("ATVPDKIKX0DER", marketplace_identifiers.marketplace_id)
      assert_equal(2, marketplace_identifiers.identifiers.length)
    end

    def test_catalog_identifier_types
      result = parse_catalog_items_response
      identifiers = result.items.first.identifiers.first.identifiers

      assert_equal("ASIN", identifiers[0].identifier_type)
      assert_equal("B001234567", identifiers[0].identifier)
      assert_equal("EAN", identifiers[1].identifier_type)
    end

    def test_error_response_structure
      result = parse_error_response

      assert_instance_of(Types::OrdersV0::GetOrdersResponse, result)
      assert_nil(result.payload)
      assert_equal(2, result.errors.length)
    end

    def test_error_details
      result = parse_error_response
      first_error = result.errors.first

      assert_instance_of(Types::OrdersV0::Error, first_error)
      assert_equal("InvalidInput", first_error.code)
      assert_equal("Invalid marketplace ID", first_error.message)
    end

    def test_error_optional_fields
      result = parse_error_response

      assert_equal("The marketplace ID provided is not valid", result.errors[0].details)
      assert_nil(result.errors[1].details)
    end

    def test_address_payload_parsing
      result = parse_address_response

      assert_instance_of(Types::OrdersV0::Address, result)
      assert_equal("John Doe", result.name)
      assert_equal("Seattle", result.city)
    end

    def test_address_optional_fields
      result = parse_address_response

      assert_equal("Apt 4B", result.address_line2)
      assert_nil(result.address_line3)
      assert_nil(result.municipality)
    end

    def test_order_with_nil_fields
      result = parse_optional_fields_response
      order = result.payload.orders.first

      assert_equal("123-4567890-1234567", order.amazon_order_id)
      assert_nil(order.seller_order_id)
      assert_nil(order.order_total)
    end

    def test_order_status_with_optional_fields
      result = parse_optional_fields_response
      order = result.payload.orders.first

      assert_equal("Pending", order.order_status)
      refute_predicate(order, :prime?)
    end

    private

    def parse_orders_response
      Types::OrdersV0::GetOrdersResponse.parse(orders_response_data)
    end

    def parse_feeds_response
      Types::Feeds20210630::GetFeedsResponse.parse(feeds_response_data)
    end

    def parse_finances_response
      Types::FinancesV0::ListFinancialEventsResponse.parse(finances_response_data)
    end

    def parse_catalog_items_response
      Types::CatalogItems20220401::ItemSearchResults.parse(catalog_items_response_data)
    end

    def parse_error_response
      Types::OrdersV0::GetOrdersResponse.parse(error_response_data)
    end

    def parse_address_response
      Types::OrdersV0::Address.parse(address_response_data)
    end

    def parse_optional_fields_response
      Types::OrdersV0::GetOrdersResponse.parse(optional_fields_response_data)
    end

    def orders_response_data
      {
        "payload" => {
          "Orders" => [
            {
              "AmazonOrderId" => "123-4567890-1234567",
              "SellerOrderId" => "SELLER123",
              "PurchaseDate" => "2024-01-15T10:30:00Z",
              "LastUpdateDate" => "2024-01-15T11:00:00Z",
              "OrderStatus" => "Shipped",
              "FulfillmentChannel" => "AFN",
              "SalesChannel" => "Amazon.com",
              "OrderChannel" => "Online",
              "ShipServiceLevel" => "Standard",
              "OrderTotal" => {
                "CurrencyCode" => "USD",
                "Amount" => "99.99",
              },
              "NumberOfItemsShipped" => 1,
              "NumberOfItemsUnshipped" => 0,
              "PaymentExecutionDetail" => [],
              "PaymentMethod" => "Other",
              "PaymentMethodDetails" => ["CreditCard"],
              "MarketplaceId" => "ATVPDKIKX0DER",
              "ShipmentServiceLevelCategory" => "Standard",
              "OrderType" => "StandardOrder",
              "EarliestShipDate" => "2024-01-16T00:00:00Z",
              "LatestShipDate" => "2024-01-17T00:00:00Z",
              "EarliestDeliveryDate" => "2024-01-18T00:00:00Z",
              "LatestDeliveryDate" => "2024-01-20T00:00:00Z",
              "IsBusinessOrder" => false,
              "IsPrime" => true,
              "IsPremiumOrder" => false,
              "IsGlobalExpressEnabled" => false,
              "IsReplacementOrder" => false,
              "IsSoldByAB" => false,
              "IsIBA" => false,
              "IsISPU" => false,
              "IsAccessPointOrder" => false,
              "HasRegulatedItems" => false,
            },
          ],
          "NextToken" => "token123",
        },
      }
    end

    def feeds_response_data
      {
        "feeds" => [
          {
            "feedId" => "ABC123",
            "feedType" => "POST_PRODUCT_DATA",
            "marketplaceIds" => ["ATVPDKIKX0DER"],
            "createdTime" => "2024-01-15T14:30:00.000Z",
            "processingStatus" => "DONE",
            "processingStartTime" => "2024-01-15T14:31:00.000Z",
            "processingEndTime" => "2024-01-15T14:32:00.000Z",
            "resultFeedDocumentId" => "DOC123",
          },
        ],
        "nextToken" => "next123",
      }
    end

    def finances_response_data
      {
        "payload" => {
          "FinancialEvents" => {
            "ShipmentEventList" => [
              {
                "AmazonOrderId" => "123-4567890-1234567",
                "SellerOrderId" => "SELLER123",
                "MarketplaceName" => "Amazon.com",
                "OrderChargeList" => [],
                "OrderChargeAdjustmentList" => [],
                "ShipmentFeeList" => [],
                "ShipmentFeeAdjustmentList" => [],
                "OrderFeeList" => [],
                "OrderFeeAdjustmentList" => [],
                "DirectPaymentList" => [],
                "PostedDate" => "2024-01-15T10:00:00Z",
                "ShipmentItemList" => [
                  {
                    "SellerSKU" => "SKU123",
                    "OrderItemId" => "ITEM123",
                    "OrderAdjustmentItemId" => "ADJ123",
                    "QuantityShipped" => 1,
                    "ItemChargeList" => [
                      {
                        "ChargeType" => "Principal",
                        "ChargeAmount" => {
                          "CurrencyCode" => "EUR",
                          "CurrencyAmount" => "49.99",
                        },
                      },
                    ],
                    "ItemChargeAdjustmentList" => [],
                    "ItemFeeList" => [],
                    "ItemFeeAdjustmentList" => [],
                    "ItemTaxWithheldList" => [],
                    "PromotionList" => [],
                    "PromotionAdjustmentList" => [],
                    "CostOfPointsGranted" => {
                      "CurrencyCode" => "EUR",
                      "CurrencyAmount" => "0.00",
                    },
                    "CostOfPointsReturned" => {
                      "CurrencyCode" => "EUR",
                      "CurrencyAmount" => "0.00",
                    },
                  },
                ],
              },
            ],
          },
        },
      }
    end

    def catalog_items_response_data
      {
        "numberOfResults" => 2,
        "items" => [
          {
            "asin" => "B001234567",
            "attributes" => {},
            "identifiers" => [
              {
                "marketplaceId" => "ATVPDKIKX0DER",
                "identifiers" => [
                  { "identifier" => "B001234567", "identifierType" => "ASIN" },
                  { "identifier" => "1234567890123", "identifierType" => "EAN" },
                ],
              },
            ],
            "images" => [],
            "productTypes" => [],
            "salesRanks" => [],
            "summaries" => [],
            "relationships" => [],
            "dimensions" => [],
          },
          {
            "asin" => "B007654321",
            "attributes" => {},
            "identifiers" => [],
            "images" => [],
            "productTypes" => [],
            "salesRanks" => [],
            "summaries" => [],
            "relationships" => [],
            "dimensions" => [],
          },
        ],
        "refinements" => {
          "brands" => [
            {
              "numberOfResults" => 10,
              "brandName" => "TestBrand",
            },
          ],
          "classifications" => [],
        },
      }
    end

    def error_response_data
      {
        "errors" => [
          {
            "code" => "InvalidInput",
            "message" => "Invalid marketplace ID",
            "details" => "The marketplace ID provided is not valid",
          },
          {
            "code" => "Unauthorized",
            "message" => "Access denied",
          },
        ],
      }
    end

    def address_response_data
      {
        "Name" => "John Doe",
        "AddressLine1" => "123 Main St",
        "AddressLine2" => "Apt 4B",
        "AddressLine3" => nil,
        "City" => "Seattle",
        "County" => "King",
        "District" => nil,
        "StateOrRegion" => "WA",
        "Municipality" => nil,
        "PostalCode" => "98101",
        "CountryCode" => "US",
        "Phone" => "555-1234",
        "AddressType" => "Residential",
      }
    end

    def optional_fields_response_data
      {
        "payload" => {
          "Orders" => [
            {
              "AmazonOrderId" => "123-4567890-1234567",
              "SellerOrderId" => nil,
              "PurchaseDate" => "2024-01-15T10:30:00Z",
              "LastUpdateDate" => "2024-01-15T11:00:00Z",
              "OrderStatus" => "Pending",
              "FulfillmentChannel" => "MFN",
              "SalesChannel" => nil,
              "OrderChannel" => nil,
              "ShipServiceLevel" => nil,
              "OrderTotal" => nil,
              "NumberOfItemsShipped" => 0,
              "NumberOfItemsUnshipped" => 1,
              "PaymentExecutionDetail" => nil,
              "PaymentMethod" => nil,
              "PaymentMethodDetails" => nil,
              "MarketplaceId" => "ATVPDKIKX0DER",
              "ShipmentServiceLevelCategory" => nil,
              "OrderType" => "StandardOrder",
              "EarliestShipDate" => nil,
              "LatestShipDate" => nil,
              "EarliestDeliveryDate" => nil,
              "LatestDeliveryDate" => nil,
              "IsBusinessOrder" => false,
              "IsPrime" => false,
              "IsPremiumOrder" => false,
              "IsGlobalExpressEnabled" => false,
              "IsReplacementOrder" => false,
              "IsSoldByAB" => false,
              "IsIBA" => false,
              "IsISPU" => false,
              "IsAccessPointOrder" => false,
              "HasRegulatedItems" => false,
            },
          ],
        },
      }
    end
  end
end
