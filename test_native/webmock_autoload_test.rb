# frozen_string_literal: true

require_relative "test_helper"
require "tmpdir"

# Peddler loads the WebMock adapter by itself, before the first exchange it makes with WebMock loaded. What is
# loaded, and when, is a fact of a process, so every scenario runs in a Ruby of its own that requires nothing of
# Peddler's but "peddler". The servers run here and count what reaches them.
# rubocop:disable Minitest/MultipleAssertions
class WebMockAutoloadTest < NativeTest
  # Every kind of exchange, as a script makes it with `client`, `lwa` and `base`
  EXCHANGES = {
    "a raw request" => 'client.request("GET", "/raw")',
    "an operation" => 'client.orders_v0.get_order("1")',
    "a page" => 'client.orders_v0.get_orders_pages(["UK"]).first',
    "a wait" => 'client.reports.wait_for_report("r1", interval: 0.01)',
    "a document by its ID" => 'client.reports.download_report_document("d1")',
    "a download" => 'client.download_document(base + "/signed") { |document| document.each_chunk.to_a }',
    "an upload" => 'client.upload_document(base + "/signed", "content", content_type: "text/plain")',
    "a feed" => 'client.feeds.create_and_upload_feed_document("content", content_type: "text/plain")',
    "a grant" => 'lwa.refresh(refresh_token: "r")',
  }.freeze

  # What a script starts with: the adapter as a count of loaded files, the hook, and a call as "sent" or the class
  # of what it raised
  PRELUDE = <<~RUBY.freeze
    Warning[:experimental] = false
    Thread.report_on_exception = false

    def adapter = $LOADED_FEATURES.grep(%r{peddler/webmock}).size

    def hooked = !Peddler::Native.instance_variable_get(:@exchange_hook).nil?

    def outcome
      yield
      "sent"
    rescue Exception => error
      error.class.name
    end

    def clients(base)
      [
        Peddler.new(base_url: base, access_token: "t"),
        Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: base + "/auth"),
      ]
    end

    # What every kind of exchange does in another Ractor: "sent", or what the Ractor is told
    def from_ractor(base)
      ractor = Ractor.new(base) do |base|
        client, lwa = clients(base)
        [#{EXCHANGES.values.map { |call| "-> { #{call} }" }.join(", ")}].map do |call|
          call.call
          "sent"
        rescue Ractor::IsolationError => error
          error.message
        end
      end
      (ractor.respond_to?(:value) ? ractor.value : ractor.take).uniq
    end
  RUBY

  # Answers every exchange of EXCHANGES
  RESPONDER = lambda do |method, target, headers, _body|
    base = "http://#{headers.fetch("host")}"
    case [method, target]
    in ["POST", "/auth"] then [200, JSON.generate(access_token: "granted", token_type: "bearer", expires_in: 3600)]
    in ["GET", "/reports/2021-06-30/reports/r1"]
      [200, JSON.generate(reportId: "r1", reportType: "T", processingStatus: "DONE", createdTime: "2024-01-01T00:00:00Z")]
    in ["GET", "/reports/2021-06-30/documents/d1"] then [200, JSON.generate(reportDocumentId: "d1", url: "#{base}/signed")]
    in ["POST", "/feeds/2021-06-30/documents"] then [201, JSON.generate(feedDocumentId: "f1", url: "#{base}/signed")]
    in ["GET", %r{\A/catalog/2022-04-01/items/B0TEST\?}] then [200, '{"asin":"B0TEST"}', [["Content-Type", "application/json"]]]
    else [200, "{}"]
    end
  end

  REFUSED = "WebMock::NetConnectNotAllowedError"
  # What a Ractor other than the main one is told while WebMock is loaded and the adapter is not, and while WebMock
  # is enabled
  LOAD = "WebMock is loaded, and its adapter for Peddler loads in the main Ractor only: require \"peddler/webmock\" " \
    "there before a call from another Ractor"
  CALL = "the exchange hook that WebMock sets answers the main Ractor only: disable WebMock or call from the main Ractor"

  def test_webmock_loaded_after_a_client_is_built_stops_every_kind_of_exchange
    scripts = EXCHANGES.transform_values do |call|
      <<~RUBY
        require "peddler"
        client, lwa = clients(base)
        require "webmock"
        WebMock.enable!
        WebMock.disable_net_connect!
        before = adapter
        print [before, outcome { #{call} }, adapter, hooked].inspect
      RUBY
    end
    # 8 threads that make their first call at once: the adapter is loaded by one, and the others wait for it.
    scripts["8 threads at once"] = <<~RUBY
      require "peddler"
      client, = clients(base)
      require "webmock"
      WebMock.enable!
      WebMock.disable_net_connect!
      print Array.new(8) { Thread.new { outcome { client.request("GET", "/raw") } } }.map(&:value).uniq.inspect
    RUBY
    expected = EXCHANGES.transform_values { [[0, REFUSED, 1, true].inspect, 0] }

    assert_equal(expected.merge("8 threads at once" => [[REFUSED].inspect, 0]), fresh(scripts))
  end

  def test_a_stub_answers_and_assert_requested_counts_with_no_require_of_the_adapter
    script = <<~RUBY
      require "peddler"
      require "webmock"
      include WebMock::API
      WebMock.enable!
      WebMock.disable_net_connect!
      orders = base + "/orders/v0/orders/1"
      stub = stub_request(:get, orders).with(headers: { "X-Amz-Access-Token" => "t" })
        .to_return(body: '{"payload":{"AmazonOrderId":"1"}}', headers: { "X-Amzn-RequestId" => "stubbed" })
      order = clients(base).first.orders_v0.get_order("1")
      assert_requested(stub, times: 1)
      assert_requested(:get, orders, times: 1)
      assert_not_requested(:get, base + "/orders/v0/orders/2")
      missing = outcome { assert_requested(:get, base + "/orders/v0/orders/2") }
      print [order.dig("payload", "AmazonOrderId"), order.headers["x-amzn-requestid"], missing, adapter].inspect
    RUBY

    assert_equal({ "a stub" => [["1", "stubbed", "RuntimeError", 1].inspect, 0] }, fresh("a stub" => script))
  end

  # Loaded late, the adapter takes WebMock as it is: never enabled, disabled, or enabled with a rule that lets the
  # request through.
  def test_the_adapter_takes_the_state_of_webmock_when_it_loads
    states = {
      "never enabled" => "",
      "disabled" => "WebMock.enable!\nWebMock.disable!",
      "net connect allowed" => "WebMock.enable!\nWebMock.allow_net_connect!",
      "localhost allowed" => "WebMock.enable!\nWebMock.disable_net_connect!(allow_localhost: true)",
      "net connect not allowed" => "WebMock.enable!\nWebMock.disable_net_connect!",
    }
    scripts = states.transform_values do |state|
      <<~RUBY
        require "peddler"
        client, = clients(base)
        require "webmock"
        #{state}
        print [outcome { client.request("GET", "/raw") }, adapter, hooked].inspect
      RUBY
    end

    assert_equal(
      {
        "never enabled" => [["sent", 1, false].inspect, 1],
        "disabled" => [["sent", 1, false].inspect, 1],
        "net connect allowed" => [["sent", 1, true].inspect, 1],
        "localhost allowed" => [["sent", 1, true].inspect, 1],
        "net connect not allowed" => [[REFUSED, 1, true].inspect, 0],
      },
      fresh(scripts),
    )
  end

  def test_without_webmock_nothing_is_loaded_and_every_exchange_is_sent
    script = <<~RUBY
      require "peddler"
      client, lwa = clients(base)
      sent = [#{EXCHANGES.values.map { |call| "outcome { #{call} }" }.join(", ")}].uniq
      print [sent, from_ractor(base), defined?(WebMock), $LOADED_FEATURES.grep(/webmock/i).size].inspect
    RUBY
    output, requests = fresh("no WebMock" => script).fetch("no WebMock")

    assert_equal([["sent"], ["sent"], nil, 0].inspect, output)
    assert_equal(2 * requests_of_every_exchange, requests)
  end

  def test_vcr_records_and_replays_with_no_require_of_the_adapter
    Dir.mktmpdir do |directory|
      cassette = lambda do |mode|
        <<~RUBY
          require "peddler"
          client = Peddler.new(base_url: base, access_token: "local-secret")
          require "vcr"
          VCR.configure do |config|
            config.hook_into(:webmock)
            config.cassette_library_dir = #{directory.inspect}
            config.filter_sensitive_data("<TOKEN>") { "local-secret" }
          end
          item = VCR.use_cassette("item", record: :#{mode}) do
            client.catalog_items_2022_04_01.get_catalog_item("B0TEST", ["A1F83G8C2ARO7P"])
          end
          other = outcome { VCR.use_cassette("item", record: :none) { client.orders_v0.get_order("1") } }
          print [item.status.code, item.parse.asin, other, adapter].inspect
        RUBY
      end
      expected = [200, "B0TEST", "VCR::Errors::UnhandledHTTPRequestError", 1].inspect
      serve_keep_alive(responder: RESPONDER) do |url, _accepted, requests|
        assert_equal(expected, run_ruby(script(url, cassette.call("once"))))
        assert_equal(1, requests.size)
        recorded = File.read(File.join(directory, "item.yml"))

        assert_includes(recorded, "#{url}/catalog/2022-04-01/items/B0TEST?includedData=summaries&marketplaceIds=A1F83G8C2ARO7P")
        assert_includes(recorded, "<TOKEN>")
        refute_includes(recorded, "local-secret")
        # A process of its own replays what the first recorded, and the server receives nothing more.
        assert_equal(expected, run_ruby(script(url, cassette.call("none"))))
        assert_equal(1, requests.size)
      end
    end
  end

  # An adapter that is loaded is told of every `enable!` and `disable!`, and infers nothing. An application loads it
  # early by requiring it, as often as it likes, with Peddler loaded or not.
  def test_an_adapter_that_an_application_requires_follows_webmock_exactly
    told = <<~RUBY
      client, = clients(base)
      results = [adapter, hooked]
      WebMock.enable!(except: [:net_http])
      results << outcome { client.request("GET", "/raw") } << hooked
      WebMock.disable_net_connect!
      WebMock.disable!
      results << outcome { client.request("GET", "/raw") } << hooked
      WebMock.enable!(except: [:peddler])
      results << outcome { client.request("GET", "/raw") } << hooked
      print results.inspect
    RUBY
    scripts = {
      "after Peddler and WebMock" => <<~RUBY,
        require "peddler"
        require "webmock"
        required = [require("peddler/webmock"), require("peddler/webmock")]
        raise "not idempotent" unless required == [true, false]
        #{told}
      RUBY
      "after WebMock and before Peddler" => <<~RUBY,
        require "webmock/minitest"
        require "peddler/webmock"
        require "peddler"
        WebMock.disable!
        #{told}
      RUBY
      "alone" => <<~RUBY,
        require "peddler/webmock"
        #{told}
      RUBY
    }
    expected = [[1, false, REFUSED, true, "sent", false, "sent", false].inspect, 2]

    assert_equal(scripts.transform_values { expected }, fresh(scripts))
  end

  # WebMock answers the main Ractor only, and only there does the adapter load and read whether WebMock is enabled.
  # So while WebMock is loaded and the adapter is not, a call from another Ractor is refused, whatever WebMock would
  # say: sent on, it could pass an enabled one. With the adapter loaded the Ractor is refused while WebMock is
  # enabled, as before. The rule is the same on every Ruby.
  def test_a_ractor_is_refused_while_webmock_is_loaded_and_the_adapter_is_not
    states = {
      "enabled" => "WebMock.enable!\nWebMock.disable_net_connect!",
      "disabled" => "WebMock.enable!\nWebMock.disable!",
      "never enabled" => "",
    }
    scripts = states.transform_values do |state|
      <<~RUBY
        require "peddler"
        require "webmock"
        #{state}
        first = [from_ractor(base), adapter]
        main = outcome { clients(base).first.request("GET", "/main") }
        print [first, main, adapter, from_ractor(base)].inspect
      RUBY
    end
    scripts["the adapter required"] = <<~RUBY
      require "peddler"
      require "webmock"
      require "peddler/webmock"
      first = [from_ractor(base), adapter]
      WebMock.enable!
      print [first, from_ractor(base)].inspect
    RUBY

    assert_equal(
      {
        "enabled" => [[[[LOAD], 0], REFUSED, 1, [CALL]].inspect, 0],
        "disabled" => [[[[LOAD], 0], "sent", 1, ["sent"]].inspect, 1 + requests_of_every_exchange],
        "never enabled" => [[[[LOAD], 0], "sent", 1, ["sent"]].inspect, 1 + requests_of_every_exchange],
        "the adapter required" => [[[["sent"], 1], [CALL]].inspect, requests_of_every_exchange],
      },
      fresh(scripts),
    )
  end

  # A suite as an application has it: WebMock's glue for Minitest and Peddler, in either order, and nothing else.
  def test_a_minitest_suite_stubs_peddler_with_webmock_required_before_it_and_after
    suite = <<~RUBY
      WITH_PEDDLER = adapter
      BASE = base
      require "minitest/autorun"

      class OrdersTest < Minitest::Test
        def setup
          WebMock.disable_net_connect!
          @client = Peddler.new(base_url: BASE, access_token: "t")
        end

        def test_a_stub_answers_and_is_counted
          stub = stub_request(:get, BASE + "/orders/v0/orders/1").to_return(body: '{"payload":{"AmazonOrderId":"1"}}')

          assert_equal("1", @client.orders_v0.get_order("1").dig("payload", "AmazonOrderId"))
          assert_requested(stub)
          assert_equal([0, 1], [WITH_PEDDLER, adapter])
        end

        def test_a_request_without_a_stub_is_refused
          assert_raises(WebMock::NetConnectNotAllowedError) { @client.orders_v0.get_order("2") }
          assert_raises(WebMock::NetConnectNotAllowedError) { @client.download_document(BASE + "/signed") }
        end
      end
    RUBY
    scripts = {
      "before" => "require \"webmock/minitest\"\nrequire \"peddler\"\n#{suite}",
      "after" => "require \"peddler\"\nrequire \"webmock/minitest\"\n#{suite}",
    }
    results = fresh(scripts)

    assert_equal(["before", "after"], results.keys)
    results.each do |order, (output, requests)|
      assert_match(/^2 runs, 5 assertions, 0 failures, 0 errors, 0 skips$/, output, order)
      assert_equal(0, requests, order)
    end
  end

  private

  # Runs each script in a Ruby of its own, all at once, each against a server of its own. Returns what each printed
  # and how many requests reached its server. A script starts with PRELUDE and the URL of its server as `base`.
  def fresh(scripts)
    scripts.map do |name, body|
      Thread.new do
        serve_keep_alive(responder: RESPONDER) do |url, _accepted, requests|
          [name, [run_ruby(script(url, body)), requests.size]]
        end
      end
    end.to_h(&:value)
  end

  def script(url, body)
    "#{PRELUDE}base = #{url.inspect}\n#{body}"
  end

  # How many requests the exchanges of EXCHANGES make: 2 of them look a document up first.
  def requests_of_every_exchange
    EXCHANGES.size + 2
  end
end
# rubocop:enable Minitest/MultipleAssertions
