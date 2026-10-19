# frozen_string_literal: true

require_relative "test_helper"
require "peddler/webmock"

# A Ractor other than the main one builds its own client and uses all of Peddler. Each scenario runs whole in a
# Ractor and returns plain values. The servers run in the main Ractor, which also compares what came back.
# rubocop:disable Minitest/MultipleAssertions
class RactorTest < NativeTest
  # Seconds a Ractor or a child process gets, so that a hang fails a test and not the run
  DEADLINE = 30

  TOKENS = JSON.generate(access_token: "granted", refresh_token: "refreshed", token_type: "bearer", expires_in: 3600,
    scope: "a::scope").freeze
  ITEM = JSON.generate(asin: "B01", summaries: [{ marketplaceId: "A1F83G8C2ARO7P", itemName: "A book" }]).freeze
  PROBLEM = JSON.generate(errors: [{ code: "QuotaExceeded", message: "Slow down" }]).freeze
  # Processes in which Ractors use a name for the first time
  FIRST_ROUNDS = Integer(ENV.fetch("FIRST_ROUNDS", "6"))
  # What a Ractor other than the main one is told of the exchange hook, which WebMock sets
  HOOK_SET = "the exchange hook is set and cleared in the main Ractor only"
  HOOK_CALL = "the exchange hook that WebMock sets answers the main Ractor only: disable WebMock or call from the main Ractor"

  def setup
    @experimental = Warning[:experimental]
    Warning[:experimental] = false
  end

  def teardown
    Warning[:experimental] = @experimental
  end

  def test_operations_pages_raw_requests_and_views
    responder = lambda do |_method, target, *|
      case target
      when /NextToken=next/ then [200, '{"payload":{"Orders":[{"AmazonOrderId":"2"}]}}']
      when %r{\A/orders/v0/orders\?} then [200, '{"payload":{"Orders":[{"AmazonOrderId":"1"}],"NextToken":"next"}}']
      else [200, '{"payload":{"AmazonOrderId":"9"}}', [["x-amzn-requestid", "request-id"]]]
      end
    end
    serve_keep_alive(responder: responder) do |url, _, requests|
      result = in_ractor(url) do |base|
        client = Peddler::Client.new(base_url: base, access_token: "ractor-token", retries: 1)
        order = client.orders_v0.get_order("9")
        pages = client.orders_v0.get_orders_pages(Peddler::Marketplace.ids("UK")).to_a
        raw = client.with_access_token("another-token").request("get", "/raw", params: { a: [1, 2] })
        regional = Peddler::Client.new(region: "eu-west-1", access_token: "ractor-token")
        [
          order.status.code,
          order.status.reason,
          order.headers["X-Amzn-RequestId"],
          order.dig("payload", "AmazonOrderId"),
          pages.map { |page| page.dig("payload", "Orders", 0, "AmazonOrderId") },
          raw.to_h,
          regional.sandbox.sandbox?,
          Peddler::Marketplace.uk.endpoint.aws_region,
        ]
      end

      assert_equal([200, "OK", "request-id", "9", ["1", "2"], { "payload" => { "AmazonOrderId" => "9" } }, true, "eu-west-1"], result)
      seen = Array.new(4) { requests.pop }

      assert_equal(["ractor-token", "ractor-token", "ractor-token", "another-token"], seen.map { |_, _, headers, _| headers["x-amz-access-token"] })
      assert_equal(["/orders/v0/orders/9", "/orders/v0/orders?MarketplaceIds=A1F83G8C2ARO7P", "/raw?a=1%2C2"], seen.values_at(0, 1, 3).map { |request| request[1] })
      assert_equal([gem_user_agent], seen.map { |_, _, headers, _| headers["user-agent"] }.uniq)
    end
  end

  def test_documents_are_streamed_waited_for_and_uploaded
    polls = 0
    responder = lambda do |method, target, headers, _body|
      base = "http://#{headers.fetch("host")}"
      case [method, target]
      in ["GET", "/reports/2021-06-30/reports/r1"]
        status = (polls += 1) > 1 ? "DONE" : "IN_PROGRESS"
        [200, JSON.generate(reportId: "r1", reportType: "T", processingStatus: status, createdTime: "2024-01-01T00:00:00Z", reportDocumentId: "d1")]
      in ["GET", "/reports/2021-06-30/documents/d1"] then [200, JSON.generate(reportDocumentId: "d1", url: "#{base}/tsv")]
      in ["GET", "/dataKiosk/2023-11-15/documents/k1"] then [200, JSON.generate(documentId: "k1", documentUrl: "#{base}/jsonl")]
      in ["GET", "/tsv"] then [200, "sku\tquantity\nA\t1\n", [["Content-Type", "text/tab-separated-values; charset=UTF-8"]]]
      in ["GET", "/jsonl"] then [200, "{\"units\":1.5}\n{\"units\":2}\n"]
      in ["GET", "/json"] then [200, '{"issues":[1]}']
      in ["POST", "/feeds/2021-06-30/documents"] then [201, JSON.generate(feedDocumentId: "f1", url: "#{base}/upload")]
      in ["PUT", _] then [200, ""]
      end
    end
    serve_keep_alive(responder: responder) do |url, _, requests|
      result = in_ractor(url) do |base|
        client = Peddler::Client.new(base_url: base, access_token: "ractor-token")
        [
          client.reports.wait_for_report("r1", interval: 0.01, timeout: 10).dig("processingStatus"),
          client.reports.open_report_document("d1") { |document| document.each_tsv.to_a },
          client.reports.download_report_document("d1").body,
          client.data_kiosk.open_query_document("k1") { |document| document.each_jsonl.map { |row| row.fetch("units").to_s } },
          client.download_document("#{base}/tsv") { |document| [document.headers["content-type"], document.each_chunk.to_a.join] },
          client.download_document("#{base}/json").json(max_bytes: 1024),
          client.upload_document("#{base}/put", StringIO.new("streamed"), content_type: "text/plain").status.code,
          client.feeds.upload_feed_document("#{base}/put", "whole", "text/xml").status.code,
          client.feeds.create_and_upload_feed_document("feed", content_type: "application/json"),
        ]
      end

      assert_equal(
        [
          "DONE",
          [["sku", "quantity"], ["A", "1"]],
          "sku\tquantity\nA\t1\n",
          ["0.15e1", "2"],
          ["text/tab-separated-values; charset=UTF-8", "sku\tquantity\nA\t1\n"],
          { "issues" => [1] },
          200,
          200,
          "f1",
        ],
        result,
      )
      puts = Array.new(requests.size) { requests.pop }.select { |method, *| method == "PUT" }

      assert_equal([["/put", "streamed"], ["/put", "whole"], ["/upload", "feed"]], puts.map { |_, target, _, body| [target, body] })
      refute(puts.any? { |_, _, headers, _| headers.key?("x-amz-access-token") })
    end
  end

  def test_lwa_grants_and_token_sources
    grants = Queue.new
    responder = lambda do |_method, target, _headers, body|
      next [200, "{}"] unless target == "/auth"

      grants << URI.decode_www_form(body).to_h.fetch("grant_type")
      [200, TOKENS]
    end
    serve_keep_alive(responder: responder) do |url, _, requests|
      result = in_ractor(url) do |base|
        lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "#{base}/auth")
        refreshed = lwa.refresh(refresh_token: "refresh")
        grantless = lwa.client_credentials(scope: "a::scope")
        exchanged = lwa.exchange_authorization_code(code: "code", redirect_uri: "https://app.example/callback")
        asked = 0
        callable = Peddler::Client.new(base_url: base, access_token: -> { "asked-#{asked += 1}" })
        managed = Peddler::Client.new(base_url: base, access_token: lwa.token_source(refresh_token: "refresh"))
        2.times { callable.request("GET", "/callable") }
        2.times { managed.request("GET", "/managed") }
        [refreshed.to_h, grantless.scope, exchanged.refresh_token, refreshed.inspect, asked]
      end

      assert_equal(
        [
          { access_token: "granted", refresh_token: "refreshed", token_type: "bearer", expires_in: 3600, scope: "a::scope" },
          "a::scope",
          "refreshed",
          "#<Peddler::LWA::Tokens [redacted]>",
          2,
        ],
        result,
      )
      # The source of Peddler::LWA keeps its token, so 2 calls make 1 grant.
      assert_equal(["refresh_token", "client_credentials", "authorization_code", "refresh_token"], Array.new(grants.size) { grants.pop })
      sent = Array.new(requests.size) { requests.pop }.reject { |_, target, *| target == "/auth" }

      assert_equal(["asked-1", "asked-2", "granted", "granted"], sent.map { |_, _, headers, _| headers["x-amz-access-token"] })
    end
  end

  # A source belongs to the Ractor that made it and is asked there before every attempt, as in the main Ractor. The
  # source of Peddler::LWA makes its grant from inside the call that asks.
  def test_a_token_source_is_asked_before_every_attempt_in_its_ractor
    attempts = Hash.new(0)
    responder = lambda do |_method, target, *|
      next [200, TOKENS] if target == "/auth"
      next [200, "{}"] if (attempts[target] += 1) > 1

      # Without Retry-After the wait is by the rate, which the call below gives.
      [429, PROBLEM, target == "/callable" ? [["Retry-After", "0"]] : []]
    end
    serve_keep_alive(responder: responder) do |url, _, requests|
      counts = in_ractor(url) do |base|
        asked = 0
        Peddler.new(base_url: base, access_token: -> { "asked-#{asked += 1}" }, retries: 1).request("GET", "/callable")
        lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "#{base}/auth")
        source = lwa.token_source(refresh_token: "refresh")
        calls = 0
        source.define_singleton_method(:call) do
          calls += 1
          super()
        end
        Peddler.new(base_url: base, access_token: source, retries: 1).orders_v0.get_order("9", rate_limit: 1000)
        [asked, calls]
      end

      assert_equal([2, 2], counts)
      sent = Array.new(requests.size) { requests.pop }.map { |_, target, headers, _| [target, headers["x-amz-access-token"]] }

      assert_equal(
        [
          ["/callable", "asked-1"],
          ["/callable", "asked-2"],
          ["/auth", nil],
          ["/orders/v0/orders/9", "granted"],
          ["/orders/v0/orders/9", "granted"],
        ],
        sent,
      )
    end
  end

  # The extension keeps a source under a name that nothing else uses, and Ruby 3.3 and 3.4 can give a name 2 IDs when
  # 2 Ractors are the first to intern it, at once. The source was then set under one and looked for under the other.
  # A name is new once in a process, so every round is a process of its own, in which 8 Ractors build their first
  # client with a source at the same moment.
  def test_first_source_clients_built_in_ractors_at_once_find_their_sources
    responder = ->(_method, _target, headers, _body) { [200, JSON.generate(token: headers["x-amz-access-token"])] }
    serve_keep_alive(responder: responder) do |url, *|
      rounds = Array.new(FIRST_ROUNDS) do
        run_ruby(<<~RUBY)
          start = Process.clock_gettime(Process::CLOCK_MONOTONIC) + 0.05
          ractors = Array.new(8) do |number|
            Ractor.new(#{url.inspect}, number, start) do |base, index, at|
              nil while Process.clock_gettime(Process::CLOCK_MONOTONIC) < at
              Peddler.new(base_url: base, access_token: -> { "token-\#{index}" }).request("GET", "/").to_h.fetch("token")
            end
          end
          puts ractors.map { |ractor| take(ractor) }.join(" ")
        RUBY
      end

      assert_equal(["#{Array.new(8) { |index| "token-#{index}" }.join(" ")}\n"] * FIRST_ROUNDS, rounds)
    end
  end

  def test_only_the_main_ractor_sets_the_exchange_hook
    serve_keep_alive do |url, _, requests|
      refused = in_ractor do
        [Object, nil].map do |hook|
          Peddler::Native.exchange_hook = hook
        rescue Ractor::IsolationError => error
          error.message
        end
      end

      assert_equal([HOOK_SET, HOOK_SET], refused)
      # So none is set, and with none a call reaches the network from either Ractor.
      assert_equal(200, client(url).request("GET", "/main").code)
      assert_equal(200, in_ractor(url) { |base| Peddler.new(base_url: base, access_token: "t").request("GET", "/ractor").code })
      assert_equal(["/main", "/ractor"], Array.new(requests.size) { requests.pop }.map { |_, target, *| target })
    end
  ensure
    Peddler::Native.exchange_hook = nil
  end

  # WebMock keeps its stubs and its record of requests in the main Ractor, and nothing of them is shareable. While it
  # is enabled, a call from another Ractor is refused. Sent on, it would reach the network from a test that believes
  # it stubbed.
  def test_webmock_answers_the_main_ractor_and_refuses_another
    serve_keep_alive do |url, _, requests|
      WebMock.enable!
      WebMock.disable_net_connect!
      WebMock.stub_request(:get, "#{url}/stubbed").to_return(body: '{"stubbed":true}')
      refused = in_ractor(url) do |base|
        client = Peddler.new(base_url: base, access_token: "ractor-token")
        calls = [
          -> { client.request("GET", "/stubbed") },
          -> { client.orders_v0.get_order("9") },
          -> { client.orders_v0.get_orders_pages(["UK"]).first },
          -> { client.reports.wait_for_report("r1") },
          -> { client.reports.open_report_document("d1") },
          -> { client.download_document("#{base}/stubbed") },
          -> { client.upload_document("#{base}/stubbed", "content", content_type: "text/plain") },
          -> { client.feeds.create_and_upload_feed_document("content", content_type: "text/plain") },
          -> { Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "#{base}/auth").refresh(refresh_token: "r") },
          -> { Peddler::Native.exchange_hook = nil },
        ]
        calls.map do |call|
          call.call
          "not refused"
        rescue Ractor::IsolationError => error
          error.message
        end
      end

      assert_equal([HOOK_CALL] * 9 + [HOOK_SET], refused)
      # The Ractor cleared nothing: the main Ractor is still answered by the stub, and nothing reached the server.
      assert_equal({ "stubbed" => true }, client(url).request("GET", "/stubbed").to_h)
      assert_equal(0, requests.size)
      WebMock.disable!

      assert_equal(200, in_ractor(url) { |base| Peddler.new(base_url: base, access_token: "t").request("GET", "/").code })
      assert_equal(1, requests.size)
    end
  ensure
    WebMock.reset!
    WebMock.disable!
  end

  def test_errors_keep_their_attributes
    responder = lambda do |_method, target, *|
      case target
      when "/auth" then [401, '{"error":"invalid_grant","error_description":"expired"}']
      when "/slow"
        sleep(0.5)
        [200, "{}"]
      when %r{\A/orders/v0/orders\?} then [200, '{"payload":{"NextToken":7}}']
      else [429, PROBLEM, [["x-amzn-requestid", "request-id"]]]
      end
    end
    serve_keep_alive(responder: responder) do |url, *|
      result = in_ractor(url) do |base|
        client = Peddler::Client.new(base_url: base, access_token: "ractor-token")
        errors = [
          -> { client.orders_v0.get_order("9") },
          -> { Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "#{base}/auth").refresh(refresh_token: "r") },
          -> { Peddler::Client.new(base_url: base, access_token: "ractor-token", timeout: 0.05).request("GET", "/slow") },
          -> { Peddler::Client.new(base_url: "http://127.0.0.1:1", access_token: "ractor-token").request("GET", "/") },
          -> { client.orders_v0.get_orders_pages(["UK"]).to_a },
          -> { client.download_document("#{base}/tsv", max_bytes: 0) },
          -> { client.reports.open_report_document("d1") },
          -> { Peddler::Client.new(base_url: base, access_token: "") },
        ].map do |call|
          call.call
          nil
        rescue StandardError => error
          error
        end
        rejected = errors.first
        matched = case rejected
        in { status: 429, code: "QuotaExceeded" } then "matched"
        end
        [
          errors.map(&:class),
          errors.map(&:message),
          [rejected.status, rejected.code, rejected.request_id, rejected.response.to_h, matched],
          [errors[1].status, errors[1].code, errors[4].reason],
        ]
      end

      assert_equal(
        [
          Peddler::Error,
          Peddler::AuthenticationError,
          Peddler::TimeoutError,
          Peddler::TransportError,
          Peddler::PaginationError,
          ArgumentError,
          Peddler::Error,
          ArgumentError,
        ],
        result[0],
      )
      assert_equal(
        [
          "Slow down",
          "authentication rejected (401)",
          "request timed out",
          "transport failed",
          "invalid token in pagination response",
          "max_bytes must be a positive Integer that fits in 64 bits",
          "Slow down",
          "invalid access token",
        ],
        result[1],
      )
      assert_equal([429, "QuotaExceeded", "request-id", JSON.parse(PROBLEM), "matched"], result[2])
      assert_equal([401, "invalid_grant", :invalid_token], result[3])
    end
  end

  # What Ruby raises in a thread of a Ractor ends its call there, as it does in the main Ractor.
  def test_a_killed_thread_leaves_its_call_and_the_ractor_goes_on
    release = Queue.new
    responder = lambda do |_method, target, *|
      release.pop if target == "/held"
      [200, "{}"]
    end
    serve_keep_alive(responder: responder) do |url, *|
      result = in_ractor(url) do |base|
        client = Peddler::Client.new(base_url: base, access_token: "ractor-token")
        thread = Thread.new { client.request("GET", "/held") }
        thread.report_on_exception = false
        sleep(0.2)
        thread.kill
        [!thread.join(10).nil?, client.request("GET", "/free").status.code]
      end

      assert_equal([true, 200], result)
    ensure
      release << true
    end
  end

  def test_four_ractors_make_fifty_calls_each_on_one_pool
    serve_keep_alive(responder: ->(_method, target, *) { [200, JSON.generate(path: target)] }) do |url, accepted, requests|
      ractors = Array.new(4) do |number|
        Ractor.new(url, number) do |base, index|
          client = Peddler::Client.new(base_url: base, access_token: "token-#{index}")
          Array.new(50) { |call| client.request("GET", "/#{index}/#{call}").dig("path") }
        end
      end
      results = ractors.map { |ractor| take(ractor) }

      assert_equal(Array.new(4) { |index| Array.new(50) { |call| "/#{index}/#{call}" } }, results)
      seen = Array.new(requests.size) { requests.pop }

      assert_equal(200, seen.size)
      # Every request carried the token of the Ractor that made it.
      assert(seen.all? { |_, target, headers, _| headers["x-amz-access-token"] == "token-#{target[%r{\A/(\d)/}, 1]}" })
      # The calls reused connections, and a Ractor that starts now finds one of them in the pool they all share.
      connections = accepted.size

      assert_operator(connections, :<, 50)
      assert_equal(200, in_ractor(url) { |base| Peddler::Client.new(base_url: base, access_token: "late").request("GET", "/").code })
      assert_equal(connections, accepted.size)
    end
  end

  def test_a_client_stays_in_its_ractor_and_a_response_can_leave_it
    serve_keep_alive(responder: ->(*) { [200, ITEM] }) do |url, *|
      client = client(url)

      assert_raises(Ractor::Error) { Ractor.make_shareable(client) }
      refute(Ractor.shareable?(client))
      # A copy can't be made, and a move is refused or leaves nothing that works behind the boundary.
      assert_raises(TypeError, Ractor::Error) { in_ractor(client) { |copy| copy.request("GET", "/").status.code } }

      response = client.catalog_items_2022_04_01.get_catalog_item("B01", ["UK"])
      copied = in_ractor(response) { |copy| [copy.status.code, copy.dig("asin"), copy.headers["content-length"]] }

      assert_equal([200, "B01", ITEM.bytesize.to_s], copied)
      shared = Ractor.make_shareable(client.catalog_items_2022_04_01.get_catalog_item("B01", ["UK"]))
      read = in_ractor(shared) { |same| [same.frozen?, same.to_h.fetch("asin"), same.dig("summaries", 0, "itemName")] }

      assert_equal([true, "B01", "A book"], read)
      returned = in_ractor(url) { |base| Peddler::Client.new(base_url: base, access_token: "t").request("GET", "/") }

      assert_equal("B01", returned.to_h.fetch("asin"))
    end
  end

  # What a Ractor raises reaches whoever takes its value as the cause of a Ractor::RemoteError.
  def test_an_error_leaves_its_ractor_as_a_cause
    serve_keep_alive(responder: ->(*) { [429, PROBLEM, [["x-amzn-requestid", "request-id"]]] }) do |url, *|
      remote = assert_raises(Ractor::RemoteError) do
        in_ractor(url) do |base|
          Thread.current.report_on_exception = false
          Peddler::Client.new(base_url: base, access_token: "t").request("GET", "/")
        end
      end
      error = remote.cause

      assert_instance_of(Peddler::Error, error)
      assert_equal([429, "QuotaExceeded", "request-id", "Slow down"], [error.status, error.code, error.request_id, error.message])
      assert_equal(JSON.parse(PROBLEM), error.response.to_h)
    end
  end

  def test_typed_models_parse_in_a_ractor
    notification = fixture("notifications/order_change.json")
    report = fixture("reports/vendor_real_time_inventory.json")
    feed = fixture("feeds/listings_feed_processing_report_with_optional_fields.json")
    row = { "startDate" => "2024-01-01", "endDate" => "2024-01-07", "marketplaceId" => "A1F83G8C2ARO7P", "sales" => { "unitsOrdered" => 3 } }
    expected = [
      Peddler::APIs::CatalogItems20220401::Item.parse(JSON.parse(ITEM)).to_h,
      Peddler::Notifications::OrderChange.parse(fixture("notifications/order_change.json")).to_h,
      Peddler::Reports::VendorRealTimeInventory.parse(fixture("reports/vendor_real_time_inventory.json")).to_h,
      Peddler::Feeds::ListingsFeedProcessingReportSchema.parse(fixture("feeds/listings_feed_processing_report_with_optional_fields.json")).to_h,
      Peddler::DataKiosk::SalesAndTraffic20240424::SalesAndTrafficByDate.parse(row.dup).to_h,
      Peddler::Money.new(amount: "1.50", currency_code: "GBP"),
      "Peddler::APIs::CatalogItems20220401::Item",
    ]
    serve_keep_alive(responder: ->(*) { [200, ITEM] }) do |url, *|
      result = in_ractor(url, notification, report, feed, row) do |base, order_change, inventory, processing, by_date|
        item = Peddler::Client.new(base_url: base, access_token: "t").catalog_items_2022_04_01.get_catalog_item("B01", ["UK"]).parse
        [
          item.to_h,
          Peddler::Notifications::OrderChange.parse(order_change).to_h,
          Peddler::Reports::VendorRealTimeInventory.parse(inventory).to_h,
          Peddler::Feeds::ListingsFeedProcessingReportSchema.parse(processing).to_h,
          Peddler::DataKiosk::SalesAndTraffic20240424::SalesAndTrafficByDate.parse(by_date).to_h,
          Peddler::Money.parse({ "Amount" => "1.5", "CurrencyCode" => "GBP" }),
          item.class.name,
        ]
      end

      assert_equal(expected, result)
    end
  end

  # Parsing a Date in several Ractors at once crashed Ruby 4.0 before structure 4.5.
  def test_ractors_parse_dates_at_once
    output = run_ruby(<<~RUBY)
      Peddler.eager_load!
      ractors = Array.new(8) do |index|
        Ractor.new(index) do |offset|
          3000.times.all? do |round|
            day = (round + offset) % 28 + 1
            parsed = Peddler::APIs::Orders20260101::ExceptionDate.parse({ "exceptionDate" => format("2024-03-%02d", day) })
            parsed.exception_date == Date.new(2024, 3, day)
          end
        end
      end
      puts ractors.map { |ractor| take(ractor) }.inspect
    RUBY

    assert_equal("#{[true] * 8}\n", output)
  end

  # The typed models load on first use. Ruby 3.3 loads code in the main Ractor only, so another Ractor finds them
  # loaded or fails. A model that is loaded parses there.
  def test_eager_load_is_what_a_ractor_needs_to_find_a_model
    without = run_ruby(<<~RUBY)
      response = Peddler::Response.new(200, [], '{"asin":"B01"}', nil, operation: "catalog_items_2022_04_01.get_catalog_item")
      puts take(Ractor.new(response) { |copy| copy.send(:parser).name })
    RUBY
    with = run_ruby(<<~RUBY)
      Peddler.eager_load!
      response = Peddler::Response.new(200, [], '{"asin":"B01"}', nil, operation: "catalog_items_2022_04_01.get_catalog_item")
      puts take(Ractor.new(response) { |copy| copy.send(:parser).name })
      puts take(Ractor.new { Peddler::Notifications::OrderChange::Notification.name })
      puts [defined?(WebMock), $LOADED_FEATURES.grep(%r{peddler/webmock}).size].inspect
    RUBY

    # Loading everything leaves the WebMock adapter alone: an application requires it or doesn't.
    assert_equal("Peddler::APIs::CatalogItems20220401::Item\nPeddler::Notifications::OrderChange::Notification\n[nil, 0]\n", with)
    if RUBY_VERSION < "3.4"
      assert_equal("Ractor::UnsafeError: call Peddler.eager_load! in the main Ractor before another Ractor parses a response\n", without)
    else
      assert_equal("Peddler::APIs::CatalogItems20220401::Item\n", without)
    end
  end

  # zeitwerk 2.6 lost them on Ruby 3.3 and 3.4, so the gem requires 2.7. It lost them once the Ractor was collected,
  # which the script sees to. A namespace is first used once in a process, so this is a process of its own.
  def test_a_model_namespace_first_used_after_a_ractor_ran_finds_its_children
    names = [
      "Peddler::Notifications::OrderChange::Notification",
      "Peddler::Notifications::AnyOfferChanged::Notification",
      "Peddler::Reports::VendorSales::Report",
      "Peddler::APIs::OrdersV0::Order",
    ]
    output = run_ruby(<<~RUBY)
      take(Ractor.new { Peddler::Marketplace.us.id })
      GC.start
      puts #{names.inspect}.map { |name| Object.const_get(name).name }
    RUBY

    assert_equal(names, output.split("\n"))
  end

  def test_eager_load_is_the_main_ractors_to_call
    refused = in_ractor do
      Peddler.eager_load!
    rescue Ractor::IsolationError => error
      error.message
    end

    assert_equal("Peddler.eager_load! works in the main Ractor only: call it there before starting another", refused)
  end

  # Everything but the typed models is loaded by `require "peddler"`, on every Ruby.
  def test_a_ractor_needs_no_loading_call_for_the_client
    output = run_ruby(<<~RUBY)
      puts take(Ractor.new {
        client = Peddler.new(region: "eu-west-1", access_token: "token").sandbox
        lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret")
        error = Peddler::Error.new("message", Peddler::Response.new(404, [], "{}"), code: "NotFound")
        [client.sandbox?, lwa.token_source(scope: "a::scope").inspect, error.status, Peddler::Marketplace.us.id, Peddler::VERSION].join(" ")
      })
      puts [defined?(WebMock), $LOADED_FEATURES.grep(%r{peddler/webmock}).size].inspect
    RUBY

    assert_equal("true #<Peddler::LWA::TokenSource> 404 ATVPDKIKX0DER #{Peddler::VERSION}\n[nil, 0]\n", output)
  end

  private

  # What the block returns from another Ractor. The block sees its arguments and nothing of the test.
  def in_ractor(*arguments, &block)
    take(Ractor.new(*arguments, &block))
  end

  def take(ractor)
    waiter = Thread.new { ractor.respond_to?(:value) ? ractor.value : ractor.take }
    waiter.report_on_exception = false
    flunk("a Ractor ran past #{DEADLINE} seconds") unless waiter.join(DEADLINE)

    waiter.value
  ensure
    waiter&.kill
  end

  def fixture(path)
    JSON.parse(File.read(File.expand_path("../test/fixtures/#{path}", __dir__)))
  end

  # A script in a Ruby of its own where nothing is loaded yet but Peddler. An error a Ractor raised prints as its
  # class and message.
  def run_ruby(script)
    super(<<~RUBY + script, deadline: DEADLINE)
      Warning[:experimental] = false
      Thread.report_on_exception = false
      require "peddler"
      def take(ractor)
        ractor.respond_to?(:value) ? ractor.value : ractor.take
      rescue Ractor::RemoteError => error
        "\#{error.cause.class}: \#{error.cause.message}"
      end
    RUBY
  end
end
# rubocop:enable Minitest/MultipleAssertions
