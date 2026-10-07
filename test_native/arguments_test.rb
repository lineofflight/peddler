# frozen_string_literal: true

require "date"
require_relative "test_helper"

# One test for each form v5 took for an argument: the bytes sent, or the error and nothing sent.
class ArgumentsTest < NativeTest
  # What the block sends, each request as "METHOD target" followed by its body if it has one
  def sent
    serve_keep_alive do |url, _accepted, requests|
      yield client(url)
      Array.new(requests.size) { requests.pop }.map { |method, target, _headers, body| [method, target, body].reject(&:empty?).join(" ") }
    end
  end

  # The message of the ArgumentError each call raises. Nothing reaches the server, and neither the message, the full
  # message nor a cause carries the value.
  def refused(*calls)
    serve_keep_alive do |url, _accepted, requests|
      messages = calls.map do |call|
        error = assert_raises(ArgumentError) { call.call(client(url)) }

        assert_nil(error.cause)
        refute_includes("#{error.message} #{error.full_message(highlight: false)} #{error.detailed_message}".b, SENTINEL)
        error.message
      end

      assert_empty(requests)
      messages
    end
  end

  def test_a_string_for_an_array_is_sent_as_v5_sent_it
    requests = sent do |client|
      client.catalog_items_2022_04_01.get_catalog_item("B0X", "ATVPDKIKX0DER", included_data: "attributes,issues")
      # A parameter the spec repeats
      client.fulfillment_inbound_2024_03_20.list_item_compliance_details("msku1", "ATVPDKIKX0DER")
    end

    assert_equal(
      [
        "GET /catalog/2022-04-01/items/B0X?includedData=attributes%2Cissues&marketplaceIds=ATVPDKIKX0DER",
        "GET /inbound/fba/2024-03-20/items/compliance?marketplaceId=ATVPDKIKX0DER&mskus=msku1",
      ],
      requests,
    )
  end

  def test_a_marketplace_is_sent_as_its_id
    uk = Peddler::Marketplace.find("UK")
    us = Peddler::Marketplace.find("US")
    requests = sent do |client|
      # In a query: alone for a list, in a list, and for a String
      client.catalog_items_2022_04_01.get_catalog_item("B0X", uk)
      client.catalog_items_2022_04_01.get_catalog_item("B0X", [uk, us])
      client.fba_inventory_v1.get_inventory_summaries("Marketplace", uk, [uk])
      # On a path, in the middle and at the end. No operation has a marketplace there; any `to_str` goes the same way.
      client.orders_v0.get_order_address(uk)
      client.orders_v0.get_order(uk)
    end

    assert_equal(
      [
        "GET /catalog/2022-04-01/items/B0X?includedData=summaries&marketplaceIds=A1F83G8C2ARO7P",
        "GET /catalog/2022-04-01/items/B0X?includedData=summaries&marketplaceIds=A1F83G8C2ARO7P%2CATVPDKIKX0DER",
        "GET /fba/inventory/v1/summaries?granularityId=A1F83G8C2ARO7P&granularityType=Marketplace&marketplaceIds=A1F83G8C2ARO7P",
        "GET /orders/v0/orders/A1F83G8C2ARO7P/address",
        "GET /orders/v0/orders/A1F83G8C2ARO7P",
      ],
      requests,
    )
  end

  def test_an_object_whose_text_is_an_inspect_form_is_refused_by_name
    point = Data.define(:x).new(x: SENTINEL)
    messages = refused(
      ->(client) { client.orders_v0.get_order(Object.new) },
      ->(client) { client.orders_v0.get_order(point) },
      ->(client) { client.orders_v0.get_order(Struct.new(:x).new(SENTINEL)) },
      ->(client) { client.orders_v0.get_orders(["UK"], seller_order_id: point) },
      ->(client) { client.catalog_items_2022_04_01.get_catalog_item("B0X", [point]) },
    )

    assert_equal(["order_id must be a String"] * 3 + ["seller_order_id must be a String", "marketplace_ids must be an Array of Strings"], messages)
    # Anything with text of its own is still sent as it, as v5 sent it.
    requests = sent { |client| client.orders_v0.get_orders([:UK], created_after: Date.new(2026, 1, 2), seller_order_id: Class.new { def to_s = "own" }.new) }

    assert_equal(["GET /orders/v0/orders?CreatedAfter=2026-01-02&MarketplaceIds=UK&SellerOrderId=own"], requests)
  end

  def test_a_to_str_that_fails_is_refused_by_name
    wrong = Class.new { def to_str = 1 }.new
    raising = Class.new do
      def to_str = raise(SENTINEL)
      def to_s = SENTINEL
    end.new
    messages = refused(
      ->(client) { client.orders_v0.get_order(wrong) },
      ->(client) { client.orders_v0.get_order(raising) },
      ->(client) { client.orders_v0.get_orders(["UK"], seller_order_id: wrong) },
      ->(client) { client.catalog_items_2022_04_01.get_catalog_item("B0X", [raising]) },
      ->(client) { client.feeds_2021_06_30.get_feeds(page_size: wrong) },
    )

    assert_equal(
      ["order_id must be a String"] * 2 + ["seller_order_id must be a String", "marketplace_ids must be an Array of Strings", "page_size must be an Integer"],
      messages,
    )
  end

  def test_a_string_that_is_not_utf8_is_refused_by_name_and_never_shown
    bad = "#{SENTINEL}\xFF"
    messages = refused(
      ->(client) { client.orders_v0.get_order(bad) },
      ->(client) { client.orders_v0.get_orders(["UK"], seller_order_id: bad) },
      ->(client) { client.catalog_items_2022_04_01.get_catalog_item("B0X", ["UK", bad]) },
      ->(client) { client.feeds_2021_06_30.get_feeds(page_size: bad) },
      # Inside a body, where only the encoder looks
      ->(client) { client.feeds_2021_06_30.create_feed({ "feedType" => bad }) },
      ->(client) { client.fba_inventory_v1.create_inventory_item({ "sku" => [bad] }) },
      ->(client) { client.feeds_2021_06_30.create_feed({ SENTINEL => Float::NAN }) },
      ->(client) { client.request("POST", "/", body: { "k" => bad }) },
    )
    json = "must be JSON: Strings of valid UTF-8 and finite numbers"

    assert_equal(
      [
        "order_id must be valid UTF-8",
        "seller_order_id must be valid UTF-8",
        "marketplace_ids must be valid UTF-8",
        "page_size must be an Integer",
        "body #{json}",
        "create_inventory_item_request_body #{json}",
        "body #{json}",
        "body #{json}",
      ],
      messages,
    )
    # Text in another encoding is sent as the UTF-8 it converts to.
    requests = sent { |client| client.orders_v0.get_order((+"caf\xE9").force_encoding("ISO-8859-1")) }

    assert_equal(["GET /orders/v0/orders/caf%C3%A9"], requests)
  end

  def test_nil_for_an_optional_keyword_is_left_out
    requests = sent { |client| client.catalog_items_2022_04_01.get_catalog_item("B0X", ["UK"], included_data: nil, locale: nil) }

    assert_equal(["GET /catalog/2022-04-01/items/B0X?marketplaceIds=UK"], requests)
  end

  def test_nil_for_a_required_argument_names_it_and_sends_nothing
    messages = refused(
      ->(client) { client.orders_v0.get_order(nil) },
      ->(client) { client.catalog_items_2022_04_01.get_catalog_item("B0X", nil) },
      ->(client) { client.feeds_2021_06_30.create_feed(nil) },
      # A body the spec names
      ->(client) { client.fba_inventory_v1.create_inventory_item(nil) },
    )

    assert_equal(
      ["order_id is required", "marketplace_ids is required", "body is required", "create_inventory_item_request_body is required"],
      messages,
    )
  end

  def test_a_string_body_is_sent_as_the_json_it_holds
    requests = sent { |client| client.feeds_2021_06_30.create_feed('{"feedType":"X","marketplaceIds":["UK"]}') }

    assert_equal(['POST /feeds/2021-06-30/feeds {"feedType":"X","marketplaceIds":["UK"]}'], requests)
    assert_equal(["body must be JSON"], refused(->(client) { client.feeds_2021_06_30.create_feed("#{SENTINEL}, and not JSON") }))
  end

  def test_a_hash_or_an_array_body_is_sent_as_json
    requests = sent do |client|
      client.feeds_2021_06_30.create_feed({ feedType: "X", "marketplaceIds" => ["UK"] })
      client.product_fees_v0.get_my_fees_estimates([{ "IdValue" => "B0X" }])
    end

    assert_equal(
      ['POST /feeds/2021-06-30/feeds {"feedType":"X","marketplaceIds":["UK"]}', 'POST /products/fees/v0/feesEstimate [{"IdValue":"B0X"}]'],
      requests,
    )
  end

  def test_a_number_for_a_string_is_sent_as_its_text
    requests = sent do |client|
      client.orders_v0.get_order(12_345)
      client.orders_v0.get_orders(["UK"], seller_order_id: 1.5)
    end

    assert_equal(["GET /orders/v0/orders/12345", "GET /orders/v0/orders?MarketplaceIds=UK&SellerOrderId=1.5"], requests)
  end

  def test_a_numeric_string_for_a_number_is_sent_as_the_number
    requests = sent do |client|
      client.feeds_2021_06_30.get_feeds(page_size: "20")
      client.shipping_v2.get_shipment_documents("s", "p", dpi: "300.5")
    end

    assert_equal(
      ["GET /feeds/2021-06-30/feeds?pageSize=20", "GET /shipping/v2/shipments/s/documents?dpi=300.5&packageClientReferenceId=p"],
      requests,
    )
    messages = refused(
      ->(client) { client.feeds_2021_06_30.get_feeds(page_size: SENTINEL) },
      ->(client) { client.shipping_v2.get_shipment_documents("s", "p", dpi: SENTINEL) },
    )

    assert_equal(["page_size must be an Integer", "dpi must be an Integer or a Float"], messages)
  end

  def test_true_and_false_as_strings_are_sent_as_booleans
    requests = sent do |client|
      client.fba_inventory_v1.get_inventory_summaries("Marketplace", "UK", ["UK"], details: "true")
      # The spec types this one as a string with a boolean format
      client.vendor_direct_fulfillment_orders_v1.get_orders("2026-01-01", "2026-01-02", include_details: "false")
    end

    assert_equal(
      [
        "GET /fba/inventory/v1/summaries?details=true&granularityId=UK&granularityType=Marketplace&marketplaceIds=UK",
        "GET /vendor/directFulfillment/orders/v1/purchaseOrders?createdAfter=2026-01-01&createdBefore=2026-01-02&includeDetails=false",
      ],
      requests,
    )
  end

  def test_any_other_type_names_the_argument_and_what_it_should_be
    messages = refused(
      ->(client) { client.orders_v0.get_order({ SENTINEL.to_sym => 1 }) },
      ->(client) { client.catalog_items_2022_04_01.get_catalog_item("B0X", [[SENTINEL]]) },
      ->(client) { client.feeds_2021_06_30.get_feeds(page_size: 1.5) },
      ->(client) { client.shipping_v2.get_shipment_documents("s", "p", dpi: [SENTINEL]) },
      ->(client) { client.fba_inventory_v1.get_inventory_summaries("Marketplace", "UK", ["UK"], details: SENTINEL) },
    )

    assert_equal(
      [
        "order_id must be a String",
        "marketplace_ids must be an Array of Strings",
        "page_size must be an Integer",
        "dpi must be an Integer or a Float",
        "details must be true or false",
      ],
      messages,
    )
  end

  def test_pages_methods_take_the_same_forms
    requests = sent { |client| client.orders_v0.get_orders_pages("ATVPDKIKX0DER", max_results_per_page: "5").first }

    assert_equal(["GET /orders/v0/orders?MarketplaceIds=ATVPDKIKX0DER&MaxResultsPerPage=5"], requests)
    assert_equal(["marketplace_ids is required"], refused(->(client) { client.orders_v0.get_orders_pages(nil) }))
  end
end
