# frozen_string_literal: true

require_relative "test_helper"
require "tmpdir"
require "vcr"
require "peddler/webmock"

# VCR's hook enables WebMock when it loads. Both stay off outside the tests below, so that the rest of the suite
# reaches its loopback servers as an application without WebMock does.
VCR.configure { |config| config.hook_into(:webmock) }
VCR.turn_off!
WebMock.disable!
WebMock::AssertionFailure.error_class = Minitest::Assertion

class WebMockTestCase < NativeTest
  include WebMock::API

  EU = "https://sellingpartnerapi-eu.amazon.com"
  UK = Peddler::Marketplace.id("UK")
  JSON_TYPE = { "Content-Type" => "application/json" }.freeze

  # WebMock's callbacks and global stubs are global, and VCR's are among them, so one of each that is registered
  # once here reports to the test that wants it.
  @observer = nil
  @global_stub = nil
  class << self
    attr_accessor :observer, :global_stub
  end
  WebMock.after_request { |signature, response| WebMockTestCase.observer&.call(signature, response) }
  WebMock.globally_stub_request { |request| WebMockTestCase.global_stub&.call(request) }

  def setup
    super
    WebMock.enable!
    WebMock.disable_net_connect!
  end

  def teardown
    WebMockTestCase.observer = nil
    WebMockTestCase.global_stub = nil
    WebMock.reset!
    WebMock.disable!
    super
  end

  def seller(**options)
    Peddler::Client.new(region: "eu-west-1", access_token: "seller-token", **options)
  end

  # WebMock counts an assertion only through its minitest glue, which this suite doesn't load.
  def assert_requested(...)
    self.assertions += 1
    super
  end

  def assert_not_requested(...)
    self.assertions += 1
    super
  end
end

# rubocop:disable Minitest/MultipleAssertions
class WebMockTest < WebMockTestCase
  def test_an_operation_is_stubbed_by_its_query_headers_and_body
    url = "#{EU}/listings/2021-08-01/items/SELLER/SKU-1"
    stub = stub_request(:put, url)
      .with(query: hash_including("marketplaceIds" => UK), body: hash_including("productType" => "LUGGAGE"),
        headers: { "X-Amz-Access-Token" => "seller-token", "Content-Type" => "application/json", "User-Agent" => gem_user_agent })
      .to_return(status: 200, body: '{"sku":"SKU-1","status":"ACCEPTED","submissionId":"s1"}',
        headers: { "Content-Type" => "application/json", "X-Amzn-RequestId" => "rid-1", "X-Repeat" => ["a", "b"] })

    response = seller.listings_items_2021_08_01.put_listings_item("SELLER", "SKU-1", [UK],
      { productType: "LUGGAGE", requirements: "LISTING", attributes: {} })

    assert_equal(200, response.status)
    assert_equal("ACCEPTED", response.parse.status)
    assert_equal("rid-1", response.headers["x-amzn-requestid"])
    assert_equal([["x-repeat", "a"], ["x-repeat", "b"]], response.headers.select { |name, _| name == "x-repeat" })
    assert_requested(stub, times: 1)
    assert_requested(:put, url, query: hash_including("includedData" => "issues"), times: 1) do |request|
      request.headers.fetch("X-Amz-Date").match?(AMZ_DATE) && JSON.parse(request.body).fetch("requirements") == "LISTING"
    end
    assert_not_requested(:put, url, query: hash_including("marketplaceIds" => "ATVPDKIKX0DER"))
    assert_not_requested(:get, /amazon/)
  end

  def test_a_stubbed_response_is_raised_on_parsed_and_paginated_as_one_from_amazon
    error = '{"errors":[{"code":"InvalidInput","message":"Amazon says no"}]}'
    stub_request(:get, "#{EU}/orders/v0/orders/1").to_return(status: 400, body: error, headers: { "x-amzn-RequestId" => "rid-2" })
    raised = assert_raises(Peddler::Error) { seller.orders_v0.get_order("1") }

    assert_equal([400, "InvalidInput", "rid-2", "Amazon says no"], [raised.status, raised.code, raised.request_id, raised.message])

    orders = "#{EU}/orders/v0/orders"
    stub_request(:get, orders).with(query: { "MarketplaceIds" => UK })
      .to_return(body: '{"payload":{"Orders":[],"NextToken":"A+/="}}', headers: JSON_TYPE)
    stub_request(:get, orders).with(query: { "MarketplaceIds" => UK, "NextToken" => "A+/=" })
      .to_return(body: '{"payload":{"Orders":[]}}', headers: JSON_TYPE)
    pages = seller.orders_v0.get_orders_pages([UK]).to_a

    assert_equal(2, pages.size)
    assert_nil(pages.last.parse.payload.next_token)
    assert_requested(:get, orders, query: hash_including("MarketplaceIds" => UK), times: 2)

    stub_request(:get, "#{EU}/any?a=1&b=x%20y").to_return(body: "plain")

    assert_equal("plain", seller.request("GET", "/any", params: { a: 1, b: "x y" }).body)
  end

  # WebMock takes a body as a String, as the parts of one, as a file to read and as what a Proc or a block returns.
  # VCR refuses the parts, for any library, and this suite hooks it into WebMock: the stubs are in a process
  # without it.
  def test_a_stubbed_body_takes_every_form_that_webmock_takes
    Dir.mktmpdir do |dir|
      path = File.join(dir, "body.json")
      File.write(path, '{"form":"file"}')
      output = run_ruby(<<~RUBY)
        require "webmock"
        require "peddler"
        include WebMock::API
        WebMock.enable!
        WebMock.disable_net_connect!
        named = ->(request) { JSON.generate(form: request.uri.path.delete_prefix("/")) }
        forms = {
          "string" => '{"form":"string"}',
          "array" => ['{"form":', '"array"}'],
          "file" => File.new(#{path.inspect}),
          "pathname" => Pathname(#{path.inspect}),
          "proc" => named,
        }
        forms.each { |name, body| stub_request(:get, "#{EU}/\#{name}").to_return(body: body) }
        stub_request(:get, "#{EU}/block").to_return { |request| { body: named.call(request) } }
        client = Peddler.new(region: "eu-west-1", access_token: "token")
        puts [*forms.keys, "block"].map { |name| client.request("GET", "/\#{name}").to_h.fetch("form") }.join(" ")
      RUBY

      assert_equal("string array file file proc block\n", output)
    end
  end

  def test_a_throttled_stub_is_retried_and_every_attempt_is_a_request_with_the_token_of_its_own
    url = "#{EU}/orders/v0/orders/1"
    stub_request(:get, url).to_return({ status: 429, headers: { "Retry-After" => "0" } }, { status: 200, body: "{}" })
    calls = 0
    client = seller(retries: 1).with_access_token(-> { "token-#{calls += 1}" })

    assert_equal(200, client.orders_v0.get_order("1").status)
    assert_requested(:get, url, times: 2)
    assert_requested(:get, url, headers: { "X-Amz-Access-Token" => "token-1" }, times: 1)
    assert_requested(:get, url, headers: { "X-Amz-Access-Token" => "token-2" }, times: 1)

    # Without retries the 429 raises, as Amazon's does.
    WebMock.reset!
    stub_request(:get, url).to_return(status: 429)

    assert_equal(429, assert_raises(Peddler::Error) { seller.orders_v0.get_order("1") }.status)
  end

  # `get_orders` allows 1 request a minute, so by its rate the first retry would wait a minute. At 100 requests a
  # second it waits 10 milliseconds and the second 20, and up to 100 more each.
  def test_a_throttled_stub_is_retried_by_the_rate_limit_of_the_call
    stub = stub_request(:get, "#{EU}/orders/v0/orders").with(query: { "MarketplaceIds" => UK })
      .to_return({ status: 429 }, { status: 429 }, { status: 200, body: '{"payload":{"Orders":[]}}', headers: JSON_TYPE })
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    response = Timeout.timeout(10) { seller(retries: 2).orders_v0.get_orders([UK], rate_limit: 100) }
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started

    assert_equal(200, response.status)
    assert_empty(response.parse.payload.orders)
    assert_operator(elapsed, :>=, 0.03)
    assert_operator(elapsed, :<, 1)
    assert_requested(stub, times: 3)
  end

  # In Amazon's sandbox the first wait after a 429 is 0.2 seconds and the second 0.4, whatever the rate: by that of
  # `get_orders` the first would be a minute. A sandbox has a region, so only a stub answers for it.
  def test_a_throttled_stub_in_the_sandbox_is_retried_after_a_fifth_of_a_second
    stub = stub_request(:get, "https://sandbox.sellingpartnerapi-eu.amazon.com/orders/v0/orders")
      .with(query: { "MarketplaceIds" => UK })
      .to_return({ status: 429 }, { status: 429 }, { status: 200, body: '{"payload":{"Orders":[]}}', headers: JSON_TYPE })
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    response = Timeout.timeout(10) { seller(retries: 2).sandbox.orders_v0.get_orders([UK]) }
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started

    assert_equal(200, response.status)
    assert_operator(elapsed, :>=, 0.6)
    assert_operator(elapsed, :<, 5)
    assert_requested(stub, times: 3)
  end

  def test_to_timeout_raises_what_a_timeout_does_and_to_raise_the_error_itself
    failure = Class.new(StandardError).new("boom")
    signed = "https://signed.example/document?X-Amz-Signature=abc"
    token_url = "https://api.amazon.com/auth/o2/token"
    document_url = "#{EU}/reports/2021-06-30/documents/d1"
    lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret")
    calls = {
      "#{EU}/orders/v0/orders/1" => [:get, -> { seller.orders_v0.get_order("1") }, Peddler::TimeoutError, "request timed out"],
      "#{EU}/raw" => [:post, -> { seller.request("POST", "/raw", body: {}) }, Peddler::TimeoutError, "request timed out"],
      token_url => [:post, -> { lwa.refresh(refresh_token: "r") }, Peddler::TimeoutError, "authentication timed out"],
      document_url => [:get, -> { seller.reports.open_report_document("d1") }, Peddler::TimeoutError, "request timed out"],
      signed => [:get, -> { seller.download_document(signed) }, Peddler::DocumentTimeoutError, "document transfer timed out"],
      "#{signed}&put" => [:put, -> { seller.upload_document("#{signed}&put", "x", content_type: "text/plain") },
        Peddler::DocumentTimeoutError, "document transfer timed out",],
    }
    calls.each do |url, (verb, call, error, message)|
      stub_request(verb, url).to_timeout
      raised = assert_raises(error, url, &call)

      assert_equal(message, raised.message)
      assert_instance_of(error, raised)

      WebMock.reset!
      stub_request(verb, url).to_raise(failure)

      assert_same(failure, assert_raises(failure.class, url, &call))
      assert_requested(verb, url, times: 1)
    end
  end

  def test_a_request_without_a_stub_raises_when_connections_are_not_allowed
    serve_keep_alive do |url, accepted, _requests|
      client = client(url)
      raised = assert_raises(WebMock::NetConnectNotAllowedError) { client.orders_v0.get_order("1") }

      assert_match(%r{Unregistered request: GET #{url}/orders/v0/orders/1}, raised.message)
      assert_raises(WebMock::NetConnectNotAllowedError) { client.download_document("#{url}/signed") }
      assert_raises(WebMock::NetConnectNotAllowedError) { client.upload_document("#{url}/signed", "x", content_type: "text/plain") }
      lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "#{url}/auth")

      assert_raises(WebMock::NetConnectNotAllowedError) { lwa.client_credentials(scope: "s") }
      assert_equal(0, accepted.size, "nothing reached the server")
      assert_requested(:get, "#{url}/orders/v0/orders/1")
    end
  end

  def test_allowed_connections_reach_the_server_and_the_callbacks_see_the_real_response
    seen = []
    WebMockTestCase.observer = ->(signature, response) { seen << [signature.method, signature.uri.path, response.status, response.body] }
    responder = lambda do |method, target, _headers, body|
      next [200, "a\tb\n1\t2\n", [["Content-Type", "text/tab-separated-values; charset=UTF-8"]]] if target == "/signed"
      next [201, "stored:#{body}"] if method == "PUT"

      [200, '{"real":true}', [["X-Amzn-RequestId", "real-1"]]]
    end
    serve_keep_alive(responder: responder) do |url, accepted, requests|
      WebMock.disable_net_connect!(allow_localhost: true)
      client = client(url)
      stub_request(:get, "#{url}/stubbed").to_return(body: "stubbed")
      response = client.orders_v0.get_order("1")

      assert_equal([200, { "real" => true }, "real-1"], [response.status, response.to_h, response.headers["x-amzn-requestid"]])
      assert_equal("stubbed", client.request("GET", "/stubbed").body)
      assert_equal([["a", "b"], ["1", "2"]], client.download_document("#{url}/signed") { |document| document.each_tsv.to_a })
      assert_equal("stored:feed", client.upload_document("#{url}/put", StringIO.new("feed"), content_type: "text/xml").body)
      assert_equal(["/orders/v0/orders/1", "/signed", "/put"], Array.new(3) { requests.pop }.map { |_, target, *| target })
      assert_operator(accepted.size, :<=, 2)
      assert_requested(:get, "#{url}/orders/v0/orders/1", headers: { "X-Amz-Access-Token" => "local-secret" })
      assert_requested(:put, "#{url}/put", body: "feed")
      assert_equal(
        [
          [:get, "/orders/v0/orders/1", [200, "OK"], '{"real":true}'],
          [:get, "/stubbed", [200, ""], "stubbed"],
          [:get, "/signed", [200, "OK"], "a\tb\n1\t2\n"],
          [:put, "/put", [201, "Created"], "stored:feed"],
        ],
        seen,
      )
    end
  end

  # WebMock may take longer than the timeout to let a request through, as a global stub that looks something up
  # does. The attempt has then timed out, and the request is not sent after all.
  def test_a_request_that_webmock_lets_through_too_late_is_not_sent
    serve_keep_alive do |url, accepted, requests|
      WebMock.disable_net_connect!(allow_localhost: true)
      WebMockTestCase.global_stub = lambda do |request|
        sleep(0.15) if request.uri.path == "/late"
        nil
      end

      assert_equal(200, client(url).request("GET", "/").status)
      requests.pop
      error = assert_raises(Peddler::TimeoutError) { client(url, timeout: 0.05).request("POST", "/late", body: {}) }

      assert_equal("request timed out", error.message)
      assert_empty(requests)
      assert_equal(200, client(url).request("GET", "/after").status)
      assert_equal(["/after"], Array.new(requests.size) { requests.pop }.map { |_, target, *| target })
      assert_equal(1, accepted.size)
    end
  end

  def test_with_webmock_disabled_peddler_reaches_the_network_and_webmock_sees_nothing
    serve_keep_alive do |url, _accepted, requests|
      stub = stub_request(:get, "#{url}/").to_return(body: "stubbed")
      WebMock.disable!

      assert_equal("{}", client(url).request("GET", "/").body)
      assert_equal(1, requests.size)
      WebMock.enable!

      assert_not_requested(stub)
      assert_equal("stubbed", client(url).request("GET", "/").body)
      assert_equal(1, requests.size)
    end
  end

  def test_a_grant_and_the_helpers_of_reports_and_feeds_go_through_stubs
    grant = stub_request(:post, "https://api.amazon.com/auth/o2/token")
      .with(body: { "grant_type" => "refresh_token", "client_id" => "id", "client_secret" => "secret", "refresh_token" => "r1" })
      .to_return(body: JSON.generate(access_token: "granted", token_type: "bearer", expires_in: 3600), headers: JSON_TYPE)
    stub_request(:post, "https://api.amazon.com/auth/o2/token").with(body: hash_including("refresh_token" => "revoked"))
      .to_return(status: 400, body: '{"error":"invalid_grant","error_description":"private"}')
    lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret")
    client = seller.with_access_token(lwa.token_source(refresh_token: "r1"))
    rejected = assert_raises(Peddler::AuthenticationError) { lwa.refresh(refresh_token: "revoked") }

    assert_equal([400, "invalid_grant"], [rejected.status, rejected.code])

    # A report by its ID: the lookup, then the signed URL, which gets no token.
    report = "https://signed.example/report?X-Amz-Signature=abc"
    lookup = stub_request(:get, "#{EU}/reports/2021-06-30/documents/doc-1").with(headers: { "X-Amz-Access-Token" => "granted" })
      .to_return(body: JSON.generate(reportDocumentId: "doc-1", url: report, compressionAlgorithm: "GZIP"), headers: JSON_TYPE)
    stub_request(:get, report).to_return(body: Zlib.gzip("sku\tquantity\nA-1\t2\n"),
      headers: { "Content-Type" => "text/tab-separated-values; charset=UTF-8" })

    assert_equal("sku\tquantity\nA-1\t2\n", client.reports.download_report_document("doc-1").body)
    assert_equal([["sku", "quantity"], ["A-1", "2"]], client.reports.open_report_document("doc-1") { |document| document.each_tsv.to_a })
    assert_requested(lookup, times: 2)
    assert_requested(grant, times: 1)
    assert_requested(:get, report, times: 2) { |request| !request.headers.key?("X-Amz-Access-Token") }

    # A job that is polled until it is done.
    job = ->(status) { { body: JSON.generate(reportId: "r1", reportType: "T", processingStatus: status, createdTime: "2024-01-01T00:00:00Z"), headers: JSON_TYPE } }
    poll = stub_request(:get, "#{EU}/reports/2021-06-30/reports/r1").to_return(job.call("IN_QUEUE"), job.call("IN_PROGRESS"), job.call("DONE"))

    assert_equal("DONE", client.reports.wait_for_report("r1", interval: 0.01).parse.processing_status)
    assert_requested(poll, times: 3)

    # A feed document: created, then uploaded with the content type it was created for.
    feed = "https://signed.example/feed?X-Amz-Signature=def"
    type = "text/xml; charset=UTF-8"
    stub_request(:post, "#{EU}/feeds/2021-06-30/documents").with(body: { "contentType" => type })
      .to_return(status: 201, body: JSON.generate(feedDocumentId: "feed-doc-1", url: feed), headers: JSON_TYPE)
    upload = stub_request(:put, feed).with(body: "<feed/>" * 20_000, headers: { "Content-Type" => type }).to_return(status: 200)

    assert_equal("feed-doc-1", client.feeds.create_and_upload_feed_document(StringIO.new("<feed/>" * 20_000), content_type: type))
    assert_requested(upload, times: 1)
    stub_request(:put, feed).to_return(status: 403, body: "<Error><Code>AccessDenied</Code></Error>")

    assert_equal(403, assert_raises(Peddler::Error) { client.feeds.upload_feed_document(feed, "<feed/>", type) }.status)
  end

  # An application may still require the adapter, any number of times. See webmock_autoload_test.rb for what loads
  # it otherwise.
  def test_the_adapter_follows_webmock_when_it_is_required_and_zeitwerk_leaves_it_alone
    # Zeitwerk would autoload the file as a constant of Peddler, and load it with everything else in production.
    name = Peddler::Inflector.new(File.expand_path("../lib/peddler.rb", __dir__)).camelize("webmock", nil)

    assert_nil(Peddler.autoload?(name))
    refute(Peddler.const_defined?(name, false))
    script = <<~RUBY
      require "peddler"
      results = [defined?(WebMock).nil?, $LOADED_FEATURES.grep(/webmock/).empty?]
      hook = -> { Peddler::Native.instance_variable_get(:@exchange_hook) }
      require "webmock"
      results << require("peddler/webmock") << !require("peddler/webmock")
      results << hook.call.nil?
      WebMock.enable!
      results << hook.call.equal?(WebMock::HttpLibAdapters::PeddlerAdapter)
      WebMock.disable!
      results << hook.call.nil?
      WebMock.enable!
      load "peddler/webmock.rb"
      results << hook.call.equal?(WebMock::HttpLibAdapters::PeddlerAdapter)
      print results.all? ? "ok" : results.inspect
    RUBY

    assert_equal("ok", run_ruby(script))
  end
end

# VCR rides on WebMock's callbacks, so a cassette records and replays what Peddler exchanges.
class WebMockVCRTest < WebMockTestCase
  CASSETTES = File.expand_path("../test/vcr_cassettes", __dir__)

  # v5 sent every list as one value with commas, and the native client repeats the parameter where Amazon's
  # model says so. Both are the same request, so a cassette of v5 is matched on the values, not the text.
  V5_URI = lambda do |recorded, sent|
    recorded, sent = [recorded, sent].map do |request|
      uri = URI(request.uri)
      [uri.host, uri.path, URI.decode_www_form(uri.query.to_s).flat_map { |name, value| value.split(",").map { |one| [name, one] } }.sort]
    end
    recorded == sent
  end

  def setup
    super
    VCR.turn_on!
  end

  def teardown
    VCR.turn_off!
    super
  end

  def test_a_cassette_is_recorded_from_a_real_server_and_replayed_with_the_server_gone
    Dir.mktmpdir do |directory|
      VCR.configure do |config|
        config.cassette_library_dir = directory
        config.filter_sensitive_data("<TOKEN>") { "local-secret" }
      end
      body = '{"asin":"B0TEST","summaries":[{"marketplaceId":"A1F83G8C2ARO7P","itemName":"Naïve café"}]}'
      url = nil
      call = ->(client) { client.catalog_items_2022_04_01.get_catalog_item("B0TEST", [UK], included_data: ["summaries"]) }
      serve_keep_alive(responder: ->(*) { [200, body, [["Content-Type", "application/json"], ["X-Amzn-RequestId", "live-1"]]] }) do |live, _accepted, requests|
        url = live
        recorded = VCR.use_cassette("recorded", record: :once) { call.call(client(url)) }

        assert_equal("Naïve café", recorded.parse.summaries.first.item_name)
        assert_equal(1, requests.size)
      end
      cassette = File.read(File.join(directory, "recorded.yml"))

      assert_includes(cassette, "uri: #{url}/catalog/2022-04-01/items/B0TEST?includedData=summaries&marketplaceIds=#{UK}")
      assert_includes(cassette, "Naïve")
      refute_includes(cassette, "base64_string")
      assert_includes(cassette, "<TOKEN>")
      refute_includes(cassette, "local-secret")
      # Nothing listens on the port any more. The cassette answers, and a request it doesn't hold raises.
      replayed = VCR.use_cassette("recorded", record: :none) do
        assert_raises(VCR::Errors::UnhandledHTTPRequestError) { client(url).orders_v0.get_order("1") }
        call.call(client(url))
      end

      assert_equal([200, body.b, "live-1"], [replayed.status, replayed.body, replayed.headers["x-amzn-requestid"]])
      assert_equal("B0TEST", replayed.parse.asin)
    end
  end

  def test_cassettes_recorded_with_v5_replay_through_vcr
    VCR.configure { |config| config.cassette_library_dir = CASSETTES }
    options = { record: :none, match_requests_on: [:method, V5_URI], allow_unused_http_interactions: false }
    lwa = Peddler::LWA.new(client_id: "FILTERED", client_secret: "FILTERED")
    included = ["classifications", "dimensions", "identifiers", "images", "productTypes", "relationships", "salesRanks", "summaries"]
    VCR.use_cassette("Peddler/APIs/CatalogItems20220401Test/test_get_catalog_item", **options) do
      token = lwa.refresh(refresh_token: "FILTERED").access_token
      client = Peddler::Client.new(region: "eu-west-1", access_token: token)
      item = client.catalog_items_2022_04_01.get_catalog_item("188864544X", [UK], included_data: included)

      assert_equal(200, item.status)
      assert_equal("188864544X", item.parse.asin)
    end
    VCR.use_cassette("Peddler/APIs/Feeds20210630Test/test_create_feed_document", **options) do
      client = Peddler::Client.new(region: "eu-west-1", access_token: -> { lwa.refresh(refresh_token: "FILTERED").access_token })
      document = client.sandbox.feeds.create_feed_document({ "contentType" => "text/tab-separated-values; charset=UTF-8" })

      assert_equal(201, document.status)
      assert_equal("3d4e42b5-1d6e-44e8-a89c-2abfca0625bb", document.parse.feed_document_id)
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
