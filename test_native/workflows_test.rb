# frozen_string_literal: true

require_relative "test_helper"
require "stringio"
require "tempfile"

# rubocop:disable Minitest/MultipleAssertions
class WorkflowsTest < NativeTest
  GZIP = [
    31, 139, 8, 0, 0, 0, 0, 0, 2, 255, 171, 86, 170, 80, 178, 50, 172, 229, 2, 0, 21, 240, 49, 80, 8, 0, 0, 0,
  ].pack("C*")

  # Answers each request with what the handler returns for its path and the base URL: [status, body] or
  # [status, body, headers]. Yields the URL and a reader of the requests so far as [path, headers, body, verb].
  def route_server(handler)
    base = nil
    responder = ->(_method, target, *) { handler.call(target, base) }
    serve_keep_alive(responder: responder) do |url, _accepted, queue|
      base = url
      log = []
      yield(url, -> { log.concat(Array.new(queue.size) { queue.pop }.map { |verb, path, headers, body| [path, headers, body, verb] }) })
    end
  end

  def report_document(base, algorithm: nil)
    document = { reportDocumentId: "d1", url: "#{base}/signed?sig=SIGNED_SECRET" }
    document[:compressionAlgorithm] = algorithm if algorithm
    JSON.generate(document)
  end

  def report(status)
    JSON.generate(reportId: "r1", reportType: "T", processingStatus: status, createdTime: "2024-01-01T00:00:00Z", reportDocumentId: "d9")
  end

  # As in v5, what belongs to an API is on its view, under both of its names. A signed URL belongs to none.
  def test_helpers_are_on_the_api_views_and_not_on_the_client
    instance = client("http://127.0.0.1:1")
    helpers = {
      [:reports, :reports_2021_06_30] => [:download_report_document, :open_report_document, :wait_for_report],
      [:feeds, :feeds_2021_06_30] => [:upload_feed_document, :download_result_feed_document, :open_feed_document, :wait_for_feed, :create_and_upload_feed_document],
      [:data_kiosk, :data_kiosk_2023_11_15] => [:download_query_document, :open_query_document, :wait_for_query],
    }
    helpers.each do |apis, names|
      names.each do |name|
        apis.each { |api| assert_respond_to(instance.public_send(api), name) }
        refute_respond_to(instance, name)
      end
    end

    [:download_document, :upload_document].each { |name| assert_respond_to(instance, name) }
  end

  def test_report_document_authenticates_metadata_but_never_the_signed_url
    handler = ->(path, base) { [200, path.start_with?("/signed") ? "report body" : report_document(base)] }
    route_server(handler) do |url, requests|
      document = client(url).reports.open_report_document("a/b c")

      assert_equal("report body", document.each_chunk.to_a.join)
      metadata, signed = requests.call

      assert_equal("/reports/2021-06-30/documents/a%2Fb%20c", metadata[0])
      assert_equal("local-secret", metadata[1]["x-amz-access-token"])
      assert_equal("/signed?sig=SIGNED_SECRET", signed[0])
      refute(signed[1].key?("x-amz-access-token"))
    end
  end

  def test_feed_and_query_documents_use_their_operations
    handler = lambda do |path, base|
      case path
      when "/signed" then [200, GZIP, [["Content-Encoding", "gzip"]]]
      when %r{\A/feeds/} then [200, JSON.generate(feedDocumentId: "f1", url: "#{base}/signed")]
      else [200, JSON.generate(documentId: "k1", documentUrl: "#{base}/signed")]
      end
    end
    route_server(handler) do |url, requests|
      instance = client(url)

      assert_equal("{\"x\":1}\n", instance.feeds.open_feed_document("f1").each_chunk.to_a.join)
      assert_equal([{ "x" => 1 }], instance.data_kiosk.open_query_document("k/1") { |document| document.each_jsonl.to_a })
      paths = requests.call.map(&:first)

      assert_equal(["/feeds/2021-06-30/documents/f1", "/signed", "/dataKiosk/2023-11-15/documents/k%2F1", "/signed"], paths)
    end
  end

  def test_unknown_compression_and_bad_metadata_never_download
    cases = {
      unknown: report_document("http://x", algorithm: "BROTLI"),
      empty_url: '{"reportDocumentId":"d1","url":""}',
      malformed: '{"url":3}',
    }
    cases.each do |name, body|
      handler = lambda do |path, base|
        flunk("downloaded") if path.start_with?("/signed")
        [200, body.gsub("http://x", base)]
      end
      route_server(handler) do |url, requests|
        error = assert_raises(Peddler::WorkflowError, name.to_s) { client(url).reports.open_report_document("d1") }

        refute_match(/SIGNED_SECRET|127\.0\.0\.1/, error.full_message(highlight: false), name.to_s)
        assert_equal(1, requests.call.size, name.to_s)
      end
    end
  end

  def test_metadata_http_error_raises_the_api_error_with_the_raw_response
    handler = ->(*) { [404, '{"errors":[{"code":"NotFound","message":"Amazon says no"}]}', [["x-amzn-requestid", "request-id"]]] }
    route_server(handler) do |url, requests|
      error = assert_raises(Peddler::Error) { client(url).feeds.open_feed_document("d1") }

      refute_kind_of(Peddler::WorkflowError, error)
      assert_equal(404, error.status)
      assert_equal("NotFound", error.code)
      assert_equal("request-id", error.request_id)
      assert_equal("Amazon says no", error.message)
      assert_includes(error.response.body, "Amazon says no")
      refute_match(/local-secret|127\.0\.0\.1/, error.message + error.inspect)
      assert_equal(1, requests.call.size)
    end
  end

  def test_invalid_arguments_fail_before_any_request
    instance = client("http://127.0.0.1:1")
    # An ID ends a path, so it is refused as a path argument is. An option is named with its rule.
    {
      -> { instance.reports.open_report_document("") } => "document_id must not be empty",
      -> { instance.reports.open_report_document(nil) } => "document_id is required",
      -> { instance.feeds.open_feed_document("..") } => "document_id must not be . or ..",
      -> { instance.reports.open_report_document("d1", max_bytes: 0) } => "max_bytes must be a positive Integer that fits in 64 bits",
      -> { instance.data_kiosk.open_query_document("d1", bogus: 1) } => "unknown option: the options are timeout, compression, max_bytes and max_record_bytes",
      -> { instance.reports.open_report_document("d1", timeout: 0) } => "timeout must be a positive number of seconds",
      -> { instance.data_kiosk.wait_for_query("") } => "query_id must not be empty",
      -> { instance.reports.wait_for_report("..") } => "report_id must not be . or ..",
      -> { instance.feeds.wait_for_feed(nil) } => "feed_id is required",
      -> { instance.reports_2021_06_30.download_report_document("..") } => "report_document_id_or_url must not be . or ..",
      -> { instance.data_kiosk_2023_11_15.download_query_document("") } => "document_id_or_url must be a UTF-8 String that is not empty",
    }.each do |call, message|
      assert_equal(message, assert_raises(ArgumentError, &call).message)
    end
    [0, -1, 1e-12, Float::NAN, Float::INFINITY, "5", nil].each do |value|
      error = assert_raises(ArgumentError, value.inspect) { instance.reports.wait_for_report("r1", interval: value) }

      assert_equal("interval must be a positive number of seconds", error.message)
      error = assert_raises(ArgumentError, value.inspect) { instance.feeds.wait_for_feed("f1", timeout: value) }

      assert_equal("timeout must be a positive number of seconds", error.message)
    end
  end

  def test_rejected_signed_url_raises_the_error_with_its_response
    handler = ->(path, base) { path.start_with?("/signed") ? [403, "signed denial"] : [200, report_document(base)] }
    route_server(handler) do |url, _|
      error = assert_raises(Peddler::Error) { client(url).reports.open_report_document("d1") }

      assert_equal(403, error.status)
      assert_equal("signed denial", error.response.body)
      refute_match(/SIGNED_SECRET|127\.0\.0\.1/, error.message)
    end
  end

  # The v5 helpers. The signed paths answer plain, gzipped with the header, gzipped without it, or with a rejection.
  def signed(path)
    case path
    when "/signed?sig=SIGNED_SECRET", "/plain" then [200, "report body"]
    when "/gzip-header" then [200, GZIP, [["Content-Encoding", "gzip"]]]
    when "/gzip" then [200, GZIP]
    when "/cp1252" then [200, "caf\xE9".b, [["Content-Type", "text/plain; charset=Cp1252"]]]
    when "/denied" then [403, "signed denial"]
    end
  end

  def assert_rejected(status)
    error = assert_raises(Peddler::Error) { yield }

    assert_equal(status, error.status)
    refute_match(/SIGNED_SECRET|127\.0\.0\.1/, error.message)
    error
  end

  def test_download_report_document_takes_an_id_or_a_url_and_returns_the_whole_body
    handler = lambda do |path, base|
      signed(path) || case path
      when %r{/documents/plain\z} then [200, report_document(base)]
      when %r{/documents/zipped\z} then [200, JSON.generate(reportDocumentId: "d1", url: "#{base}/gzip", compressionAlgorithm: "GZIP")]
      else [404, '{"errors":[{"code":"NotFound","message":"Amazon says no"}]}']
      end
    end
    route_server(handler) do |url, requests|
      reports = client(url).reports

      assert_instance_of(Peddler::Native::Reports20210630, client(url).reports_2021_06_30)
      response = reports.download_report_document("plain")

      assert_instance_of(Peddler::Response, response)
      assert_equal([200, "report body"], [response.status, response.body])
      assert_equal("11", response.headers["Content-Length"])
      assert_equal("{\"x\":1}\n", reports.download_report_document("zipped").body)
      metadata, document = requests.call.last(2)

      assert_equal("/reports/2021-06-30/documents/zipped", metadata[0])
      assert_equal("local-secret", metadata[1]["x-amz-access-token"])
      refute(document[1].key?("x-amz-access-token"))
      assert_equal("report body", reports.download_report_document("#{url}/plain").body)
      assert_equal({ "x" => 1 }, reports.download_report_document("#{url}/gzip-header").to_h)
      # Read as v5 code read it.
      report = reports.download_report_document("#{url}/cp1252")

      assert_predicate(report.status, :success?)
      assert_equal(["Cp1252", "café"], [report.charset, report.to_s.encode("UTF-8")])
      assert_equal("signed denial", assert_rejected(403) { reports.download_report_document("#{url}/denied") }.response.body)
      assert_equal("NotFound", assert_rejected(404) { reports.download_report_document("missing") }.code)
    end
  end

  def test_upload_feed_document_puts_the_content_with_its_type_and_length
    handler = ->(path, _) { path == "/denied" ? [403, "upload denied"] : [200, ""] }
    route_server(handler) do |url, requests|
      feeds = client(url).feeds

      assert_instance_of(Peddler::Native::Feeds20210630, client(url).feeds_2021_06_30)
      response = feeds.upload_feed_document("#{url}/signed?sig=SIGNED_SECRET", "<x>é</x>", "text/xml; charset=UTF-8")

      assert_instance_of(Peddler::Response, response)
      assert_equal(200, response.status)
      path, headers, body, verb = requests.call.first

      assert_equal(["PUT", "/signed?sig=SIGNED_SECRET", "<x>é</x>".b], [verb, path, body])
      assert_equal(["text/xml; charset=UTF-8", "9"], headers.values_at("content-type", "content-length"))
      refute(headers.key?("x-amz-access-token"))
      assert_equal("upload denied", assert_rejected(403) { feeds.upload_feed_document("#{url}/denied", "<x/>", "text/xml") }.response.body)
    end
  end

  def test_feed_uploads_declare_the_length_of_a_file_and_a_string_io
    Tempfile.create("feed") do |file|
      file.write("<x>é</x>")
      route_server(feed_handler) do |url, requests|
        instance = client(url)
        [file, StringIO.new("<x>é</x>")].each do |source|
          source.rewind
          instance.feeds.upload_feed_document("#{url}/signed", source, "text/xml")
          source.rewind

          assert_equal("fd/1", instance.feeds.create_and_upload_feed_document(source, content_type: "text/xml"))
        end
        # upload_feed_document takes no content_length:, so a source with a size and no position needs this.
        instance.feeds.upload_feed_document("#{url}/signed", sized_source("<x>é</x>"), "text/xml")
        instance.feeds.create_and_upload_feed_document(sized_source("<x>é</x>"), content_type: "text/xml")
        puts = requests.call.select { |_path, _headers, _body, verb| verb == "PUT" }

        assert_equal([["9", nil, "<x>é</x>".b]] * 6, puts.map { |_path, headers, body| [headers["content-length"], headers["transfer-encoding"], body] })
      end
    end
  end

  def test_download_result_feed_document_returns_the_whole_body
    route_server(->(path, _) { signed(path) }) do |url, requests|
      feeds = client(url).feeds
      response = feeds.download_result_feed_document("#{url}/gzip-header")

      assert_instance_of(Peddler::Response, response)
      assert_equal([200, "{\"x\":1}\n"], [response.status, response.body])
      assert_equal("report body", feeds.download_result_feed_document("#{url}/plain").body)
      refute(requests.call.any? { |_, headers, _| headers.key?("x-amz-access-token") })
      assert_equal("signed denial", assert_rejected(403) { feeds.download_result_feed_document("#{url}/denied") }.response.body)
    end
  end

  def test_download_query_document_takes_an_id_or_a_url_and_returns_the_whole_body
    handler = lambda do |path, base|
      signed(path) || case path
      when %r{/documents/k1\z} then [200, JSON.generate(documentId: "k1", documentUrl: "#{base}/gzip-header")]
      else [404, '{"errors":[{"code":"NotFound","message":"Amazon says no"}]}']
      end
    end
    route_server(handler) do |url, requests|
      kiosk = client(url).data_kiosk

      assert_instance_of(Peddler::Native::DataKiosk20231115, client(url).data_kiosk_2023_11_15)
      response = kiosk.download_query_document("k1")

      assert_instance_of(Peddler::Response, response)
      assert_equal([200, "{\"x\":1}\n"], [response.status, response.body])
      assert_equal(["/dataKiosk/2023-11-15/documents/k1", "/gzip-header"], requests.call.map(&:first))
      assert_equal("report body", kiosk.download_query_document("#{url}/plain").body)
      assert_equal("signed denial", assert_rejected(403) { kiosk.download_query_document("#{url}/denied") }.response.body)
      assert_equal("NotFound", assert_rejected(404) { kiosk.download_query_document("missing") }.code)
    end
  end

  def test_helpers_allow_600_seconds_for_the_whole_call
    seen = []
    config = Peddler::Native::TransferConfig.method(:json)
    handler = lambda do |path, base|
      signed(path) || [200, path.include?("dataKiosk") ? JSON.generate(documentId: "k1", documentUrl: "#{base}/plain") : report_document(base)]
    end
    route_server(handler) do |url, _|
      instance = client(url)
      recording = lambda do |options|
        seen << options
        config.call(options)
      end
      Peddler::Native::TransferConfig.stub(:json, recording) do
        instance.reports.download_report_document("d1")
        instance.feeds.download_result_feed_document("#{url}/plain")
        instance.feeds.upload_feed_document("#{url}/plain", "x", "text/plain")
        instance.data_kiosk.download_query_document("k1")
      end
    end

    assert_equal([{ timeout: 600 }] * 4, seen)
  end

  def test_wait_polls_until_done_with_integer_and_float_options
    statuses = %w[IN_QUEUE IN_PROGRESS DONE]
    count = 0
    handler = lambda do |*|
      count += 1
      [200, report(statuses[[count - 1, 2].min])]
    end
    route_server(handler) do |url, requests|
      response = client(url).reports.wait_for_report("r/1", interval: 0.05, timeout: 5)

      assert_equal("DONE", response.to_h.fetch("processingStatus"))
      assert_equal("d9", response.to_h.fetch("reportDocumentId"))
      assert_equal(200, response.status)
      assert_equal(["/reports/2021-06-30/reports/r%2F1"] * 3, requests.call.map(&:first))
    end
  end

  def test_wait_returns_feed_and_query_ids
    handler = lambda do |path, _|
      if path.include?("/feeds/")
        [200, JSON.generate(feedId: "f1", feedType: "T", processingStatus: "FATAL", createdTime: "2024-01-01T00:00:00Z", resultFeedDocumentId: "rf")]
      else
        [200, JSON.generate(queryId: "q1", query: "x", processingStatus: "DONE", createdTime: "2024-01-01T00:00:00Z", dataDocumentId: "dd", errorDocumentId: "ed")]
      end
    end
    route_server(handler) do |url, requests|
      instance = client(url)

      assert_equal("rf", instance.feeds.wait_for_feed("f1", interval: 0.01, timeout: 2).to_h.fetch("resultFeedDocumentId"))
      query = instance.data_kiosk.wait_for_query("q1", interval: 0.01, timeout: 2).to_h

      assert_equal(["dd", "ed"], [query.fetch("dataDocumentId"), query.fetch("errorDocumentId")])
      assert_equal("/dataKiosk/2023-11-15/queries/q1", requests.call.last.first)
    end
  end

  def test_the_response_of_a_wait_parses_to_the_typed_model_of_its_operation
    handler = lambda do |path, _|
      case path
      when %r{\A/reports/} then [200, report("DONE")]
      when %r{\A/feeds/} then [200, JSON.generate(feedId: "f1", feedType: "T", processingStatus: "DONE", createdTime: "2024-01-01T00:00:00Z", resultFeedDocumentId: "rf")]
      else [200, JSON.generate(queryId: "q1", query: "x", processingStatus: "DONE", createdTime: "2024-01-01T00:00:00Z", dataDocumentId: "dd")]
      end
    end
    route_server(handler) do |url, _|
      instance = client(url)
      report = instance.reports.wait_for_report("r1").parse
      feed = instance.feeds.wait_for_feed("f1").parse
      query = instance.data_kiosk.wait_for_query("q1").parse

      assert_instance_of(Peddler::APIs::Reports20210630::Report, report)
      assert_equal(["DONE", "d9", Time.utc(2024, 1, 1)], [report.processing_status, report.report_document_id, report.created_time])
      assert_instance_of(Peddler::APIs::Feeds20210630::Feed, feed)
      assert_equal(["DONE", "rf"], [feed.processing_status, feed.result_feed_document_id])
      assert_instance_of(Peddler::APIs::DataKiosk20231115::Query, query)
      assert_equal(["DONE", "dd"], [query.processing_status, query.data_document_id])
    end
  end

  def test_wait_rejects_unknown_status_stops_on_http_errors_and_malformed_json
    route_server(->(*) { [200, report("SOMETHING_NEW")] }) do |url, requests|
      error = assert_raises(Peddler::WorkflowError) { client(url).reports.wait_for_report("r1", interval: 0.01, timeout: 2) }

      refute_match(/SOMETHING_NEW/, error.message)
      assert_equal(1, requests.call.size)
    end
    route_server(->(*) { [429, '{"errors":[]}'] }) do |url, requests|
      error = assert_raises(Peddler::Error) { client(url).reports.wait_for_report("r1", interval: 0.01, timeout: 2) }

      assert_equal(429, error.status)
      assert_equal(429, error.response.status)
      assert_equal(1, requests.call.size)
    end
    route_server(->(*) { [200, '{"processingStatus":1}'] }) do |url, _|
      assert_raises(Peddler::WorkflowError) { client(url).reports.wait_for_report("r1", interval: 0.01, timeout: 2) }
    end
    route_server(->(*) { [200, report("IN_QUEUE")] }) do |url, _|
      assert_raises(Peddler::WorkflowTimeoutError) { client(url).reports.wait_for_report("r1", interval: 0.01, timeout: 0.05) }
    end
  end

  # Answers every lookup, poll and signed URL, but a path that matches `slow` only after 2 seconds.
  def slow_server(slow, &block)
    handler = lambda do |path, base|
      sleep(2) if path.match?(slow)
      case path
      when %r{\A/signed} then [200, "body"]
      when %r{\A/reports/2021-06-30/reports/} then [200, report("IN_QUEUE")]
      when %r{\A/reports/} then [200, report_document(base)]
      when %r{\A/feeds/} then [path.end_with?("/documents") ? 201 : 200, JSON.generate(feedDocumentId: "f1", url: "#{base}/signed")]
      else [200, JSON.generate(documentId: "k1", documentUrl: "#{base}/signed")]
      end
    end
    route_server(handler, &block)
  end

  # What ran out of time decides the class: a lookup is a request, a transfer is a document, and only a wait is
  # a workflow.

  def test_a_slow_lookup_raises_the_timeout_of_a_request
    slow_server(%r{/documents}) do |url, _|
      instance = client(url)
      hasty = client(url, timeout: 0.1)

      [
        -> { instance.reports.open_report_document("d1", timeout: 0.1) },
        -> { instance.feeds.open_feed_document("d1", timeout: 0.1) },
        -> { instance.data_kiosk.open_query_document("d1", timeout: 0.1) },
        -> { instance.feeds.create_and_upload_feed_document("content", content_type: "text/xml", timeout: 0.1) },
        -> { hasty.reports.open_report_document("d1") },
        -> { hasty.reports.download_report_document("d1") },
        -> { hasty.data_kiosk.download_query_document("d1") },
      ].each { |call| assert_raises(Peddler::TimeoutError, &call) }
    end
  end

  def test_a_slow_transfer_raises_the_timeout_of_a_document
    slow_server(%r{\A/signed}) do |url, _|
      instance = client(url)

      [
        -> { instance.reports.open_report_document("d1", timeout: 0.1) },
        -> { instance.feeds.open_feed_document("d1", timeout: 0.1) },
        -> { instance.data_kiosk.open_query_document("d1", timeout: 0.1) },
        -> { instance.feeds.create_and_upload_feed_document("content", content_type: "text/xml", timeout: 0.1) },
        -> { instance.download_document("#{url}/signed", timeout: 0.1) },
        -> { instance.upload_document("#{url}/signed", "content", content_type: "text/xml", timeout: 0.1) },
      ].each { |call| assert_raises(Peddler::DocumentTimeoutError, &call) }
    end
  end

  def test_only_a_wait_past_its_own_timeout_raises_the_timeout_of_a_workflow
    slow_server(%r{/reports/r1}) do |url, _|
      # One poll took longer than the client allows a request, with most of the wait's time left.
      assert_raises(Peddler::TimeoutError) { client(url, timeout: 0.1).reports.wait_for_report("r1", interval: 0.01, timeout: 5) }
      assert_raises(Peddler::WorkflowTimeoutError) { client(url).reports.wait_for_report("r1", interval: 0.01, timeout: 0.1) }
    end
  end

  def test_thread_kill_ends_a_wait_and_the_client_recovers
    polls = Queue.new
    status = "IN_PROGRESS"
    handler = lambda do |*|
      polls << true
      [200, report(status)]
    end
    route_server(handler) do |url, _|
      instance = client(url)
      thread = Thread.new { instance.reports.wait_for_report("r1", interval: 0.02, timeout: 30) }
      Timeout.timeout(5) { polls.pop }
      thread.kill

      assert(thread.join(1), "interrupted wait must return")
      status = "DONE"

      assert_equal("DONE", instance.reports.wait_for_report("r1", interval: 0.01, timeout: 2).to_h.fetch("processingStatus"))
    end
  end

  def test_a_wakeup_does_not_end_a_wait
    polls = Queue.new
    status = "IN_PROGRESS"
    handler = lambda do |*|
      polls << true
      [200, report(status)]
    end
    route_server(handler) do |url, _|
      instance = client(url)
      thread = Thread.new { instance.reports.wait_for_report("r1", interval: 0.02, timeout: 5) }
      2.times do
        Timeout.timeout(3) { polls.pop }
        thread.wakeup
      end
      status = "DONE"

      assert(thread.join(3), "wait did not finish")
      assert_equal("DONE", thread.value.to_h.fetch("processingStatus"))
    ensure
      thread&.kill
      thread&.join
    end
  end

  def feed_handler(upload_status: 200, upload_body: "", **options)
    lambda do |path, base|
      if path.start_with?("/signed")
        [upload_status, upload_body]
      else
        [options.fetch(:create_status, 201), options.fetch(:create_body) { JSON.generate(feedDocumentId: "fd/1", url: "#{base}/signed?sig=SIGNED_SECRET") }]
      end
    end
  end

  def test_feed_document_is_created_then_uploaded_with_exact_type_and_multi_read_bytes
    payload = "a\tb\n".b * 50_000
    reads = []
    io = StringIO.new(payload)
    io.define_singleton_method(:read) do |length|
      reads << length
      super(length)
    end
    route_server(feed_handler) do |url, requests|
      type = "text/tab-separated-values; charset=UTF-8"
      uploaded = client(url).feeds.create_and_upload_feed_document(io, content_type: type, content_length: payload.bytesize)

      assert_equal("fd/1", uploaded)
      create, put = requests.call

      assert_equal(["POST", "/feeds/2021-06-30/documents"], [create[3], create[0]])
      assert_equal("local-secret", create[1]["x-amz-access-token"])
      assert_equal({ "contentType" => type }, JSON.parse(create[2]))
      assert_equal(type, put[1].fetch("content-type"))
      refute(put[1].key?("x-amz-access-token"))
      assert_equal(payload, put[2])
      assert_equal(2, requests.call.size, "no createFeed")
    end
    assert_operator(reads.size, :>=, 4)
    assert(reads.all?(64 * 1024))
  end

  def test_string_source_and_invalid_metadata_never_read_the_source
    route_server(feed_handler) do |url, _|
      assert_equal("fd/1", client(url).feeds.create_and_upload_feed_document("<x/>", content_type: "text/xml"))
    end
    bodies = [
      { create_body: '{"feedDocumentId":"fd1","url":""}' },
      { create_body: '{"feedDocumentId":"fd1","url":"ftp://x/y"}' },
      { create_body: "not json" },
      { create_status: 400, create_body: '{"errors":[{"code":"InvalidInput","message":"Amazon says no"}]}' },
    ]
    bodies.each do |options|
      touched = false
      source = Object.new
      source.define_singleton_method(:read) do |_|
        touched = true
        nil
      end
      route_server(feed_handler(**options)) do |url, requests|
        # A failed create is the API error; anything else wrong with the metadata is a workflow error.
        expected = options[:create_status] ? Peddler::Error : Peddler::WorkflowError
        error = assert_raises(expected) { client(url).feeds.create_and_upload_feed_document(source, content_type: "text/xml") }

        refute(touched, options.inspect)
        refute_match(/127\.0\.0\.1|SIGNED_SECRET/, error.full_message(highlight: false))
        assert_equal(1, requests.call.size)
        next unless options[:create_status]

        assert_equal([400, "InvalidInput", "Amazon says no"], [error.status, error.code, error.message])
      end
    end
  end

  def test_invalid_arguments_are_rejected_before_creating_a_document
    instance = client("http://127.0.0.1:1")

    upload = ->(source = "x", **options) { instance.feeds.create_and_upload_feed_document(source, **{ content_type: "text/xml" }.merge(options)) }

    {
      -> { upload.call(content_type: "") } => "content_type must be a UTF-8 String that is not empty",
      -> { upload.call(content_type: nil) } => "content_type must be a UTF-8 String that is not empty",
      -> { upload.call(content_type: 1) } => "content_type must be a UTF-8 String that is not empty",
      -> { upload.call(Object.new) } => "source must be a String or respond to read",
      -> { upload.call(content_length: -1) } => "content_length must be an Integer from 0 that fits in 64 bits",
      -> { upload.call(content_length: 6, max_bytes: 5) } => "content_length must not be more than max_bytes",
      -> { upload.call(content_type: "bad\r\ntype") } => "content_type must be a header value, without control characters",
      -> { upload.call(bogus: 1) } => "unknown option: the options are timeout, compression, max_bytes and max_record_bytes",
    }.each do |call, message|
      assert_equal(message, assert_raises(ArgumentError, &call).message)
    end
  end

  # A source larger than max_bytes is refused as upload_document refuses it, before a feed document is created.
  # The caller gave no content_length:, so the error doesn't name one.
  def test_a_source_larger_than_max_bytes_is_refused_as_an_upload_to_a_signed_url_is
    route_server(feed_handler) do |url, requests|
      instance = client(url)
      Tempfile.create("feed") do |file|
        file.write("0123456789")
        ["0123456789", file, StringIO.new("0123456789"), sized_source("0123456789")].each do |source|
          calls = [
            -> { instance.feeds.create_and_upload_feed_document(source, content_type: "text/xml", max_bytes: 5) },
            -> { instance.upload_document("#{url}/signed", source, content_type: "text/xml", max_bytes: 5) },
          ]
          calls.each do |call|
            source.rewind if source.respond_to?(:rewind)
            error = assert_raises(Peddler::DocumentError, &call)

            assert_equal([Peddler::DocumentError, "document byte limit exceeded"], [error.class, error.message])
          end
        end
      end

      assert_empty(requests.call)
    end
  end

  def test_upload_rejection_raises_and_failures_are_sanitized
    route_server(feed_handler(upload_status: 403, upload_body: "upload denied")) do |url, requests|
      error = assert_raises(Peddler::Error) { client(url).feeds.create_and_upload_feed_document("x", content_type: "text/xml") }

      assert_equal(403, error.status)
      assert_equal("upload denied", error.response.body)
      refute_match(/SIGNED_SECRET/, error.full_message(highlight: false))
      assert_equal(2, requests.call.size, "neither mutation retried")
    end
    route_server(feed_handler) do |url, _|
      error = assert_raises(Peddler::DocumentError) { client(url).feeds.create_and_upload_feed_document("abc", content_type: "text/xml", content_length: 5) }

      refute_match(/SIGNED_SECRET/, error.full_message(highlight: false))
      source_error = RuntimeError.new("private-secret")
      source = Object.new
      source.define_singleton_method(:read) { |_| raise source_error }
      error = assert_raises(Peddler::DocumentError) { client(url).feeds.create_and_upload_feed_document(source, content_type: "text/xml") }

      assert_same(source_error, error.cause)
      refute_match(/private-secret/, error.message)
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
