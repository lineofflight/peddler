# frozen_string_literal: true

require_relative "test_helper"
require "stringio"

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

  def test_report_document_authenticates_metadata_but_never_the_signed_url
    handler = ->(path, base) { [200, path.start_with?("/signed") ? "report body" : report_document(base)] }
    route_server(handler) do |url, requests|
      document = client(url).open_report_document("a/b c")

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

      assert_equal("{\"x\":1}\n", instance.open_feed_document("f1").each_chunk.to_a.join)
      assert_equal([{ "x" => 1 }], instance.open_query_document("k/1") { |document| document.each_jsonl.to_a })
      paths = requests.call.map(&:first)

      assert_equal(["/feeds/2021-06-30/documents/f1", "/signed", "/dataKiosk/2023-11-15/documents/k%2F1", "/signed"], paths)
    end
  end

  def test_bad_compression_conflicts_and_metadata_never_download
    cases = {
      unknown: [report_document("http://x", algorithm: "BROTLI"), {}, Peddler::WorkflowError],
      conflict: [report_document("http://x", algorithm: "GZIP"), { compression: :none }, Peddler::WorkflowError],
      absent_gzip: [report_document("http://x"), { compression: :gzip }, Peddler::WorkflowError],
      empty_url: ['{"reportDocumentId":"d1","url":""}', {}, Peddler::WorkflowError],
      malformed: ['{"url":3}', {}, Peddler::WorkflowError],
    }
    cases.each do |name, (body, options, error_class)|
      handler = lambda do |path, base|
        flunk("downloaded") if path.start_with?("/signed")
        [200, body.gsub("http://x", base)]
      end
      route_server(handler) do |url, requests|
        error = assert_raises(error_class, name.to_s) { client(url).open_report_document("d1", **options) }

        refute_match(/SIGNED_SECRET|127\.0\.0\.1/, error.full_message(highlight: false), name.to_s)
        assert_equal(1, requests.call.size, name.to_s)
      end
    end
  end

  def test_metadata_http_error_raises_the_api_error_with_the_raw_response
    handler = ->(*) { [404, '{"errors":[{"code":"NotFound","message":"Amazon says no"}]}', [["x-amzn-requestid", "request-id"]]] }
    route_server(handler) do |url, requests|
      error = assert_raises(Peddler::Error) { client(url).open_feed_document("d1") }

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
    assert_raises(ArgumentError) { instance.open_report_document("") }
    assert_raises(ArgumentError) { instance.open_report_document(nil) }
    assert_raises(ArgumentError) { instance.open_report_document("d1", max_bytes: 0) }
    assert_raises(ArgumentError) { instance.open_report_document("d1", bogus: 1) }
    [0, -1, Float::NAN, Float::INFINITY, "5", nil].each do |value|
      assert_raises(ArgumentError, value.inspect) { instance.wait_for_report("r1", interval: value) }
      assert_raises(ArgumentError, value.inspect) { instance.wait_for_feed("f1", timeout: value) }
    end
    assert_raises(ArgumentError) { instance.wait_for_query("") }
  end

  def test_transfer_non_success_keeps_download_semantics_and_limits
    handler = ->(path, base) { path.start_with?("/signed") ? [403, "signed denial"] : [200, report_document(base)] }
    route_server(handler) do |url, _|
      document = client(url).open_report_document("d1", max_response_bytes: 6)

      assert_equal(403, document.status)
      assert_equal("signed", document.error_body)
      assert_predicate(document, :error_body_truncated?)
    end
  end

  def test_wait_polls_until_done_with_integer_and_float_options
    statuses = %w[IN_QUEUE IN_PROGRESS DONE]
    count = 0
    handler = lambda do |*|
      count += 1
      [200, report(statuses[[count - 1, 2].min])]
    end
    route_server(handler) do |url, requests|
      response = client(url).wait_for_report("r/1", interval: 0.05, timeout: 5)

      assert_equal("DONE", response.json.fetch("processingStatus"))
      assert_equal("d9", response.json.fetch("reportDocumentId"))
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

      assert_equal("rf", instance.wait_for_feed("f1", interval: 0.01, timeout: 2).json.fetch("resultFeedDocumentId"))
      query = instance.wait_for_query("q1", interval: 0.01, timeout: 2).json

      assert_equal(["dd", "ed"], [query.fetch("dataDocumentId"), query.fetch("errorDocumentId")])
      assert_equal("/dataKiosk/2023-11-15/queries/q1", requests.call.last.first)
    end
  end

  def test_wait_rejects_unknown_status_stops_on_http_errors_and_malformed_json
    route_server(->(*) { [200, report("SOMETHING_NEW")] }) do |url, requests|
      error = assert_raises(Peddler::WorkflowError) { client(url).wait_for_report("r1", interval: 0.01, timeout: 2) }

      refute_match(/SOMETHING_NEW/, error.message)
      assert_equal(1, requests.call.size)
    end
    route_server(->(*) { [429, '{"errors":[]}'] }) do |url, requests|
      error = assert_raises(Peddler::Error) { client(url).wait_for_report("r1", interval: 0.01, timeout: 2) }

      assert_equal(429, error.status)
      assert_equal(429, error.response.status)
      assert_equal(1, requests.call.size)
    end
    route_server(->(*) { [200, '{"processingStatus":1}'] }) do |url, _|
      assert_raises(Peddler::WorkflowError) { client(url).wait_for_report("r1", interval: 0.01, timeout: 2) }
    end
    route_server(->(*) { [200, report("IN_QUEUE")] }) do |url, _|
      assert_raises(Peddler::WorkflowTimeoutError) { client(url).wait_for_report("r1", interval: 0.01, timeout: 0.05) }
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
      thread = Thread.new { instance.wait_for_report("r1", interval: 0.02, timeout: 30) }
      Timeout.timeout(5) { polls.pop }
      thread.kill

      assert(thread.join(1), "interrupted wait must return")
      status = "DONE"

      assert_equal("DONE", instance.wait_for_report("r1", interval: 0.01, timeout: 2).json.fetch("processingStatus"))
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
      uploaded = client(url).create_and_upload_feed_document(io, content_type: type, content_length: payload.bytesize)

      assert_equal("fd/1", uploaded.document_id)
      assert_equal(200, uploaded.response.status)
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
      assert_equal(200, client(url).create_and_upload_feed_document("<x/>", content_type: "text/xml").response.status)
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
        error = assert_raises(expected) { client(url).create_and_upload_feed_document(source, content_type: "text/xml") }

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

    ["", "bad\r\ntype", nil, 1].each { |type| assert_raises(ArgumentError, type.inspect) { instance.create_and_upload_feed_document("x", content_type: type) } }
    assert_raises(ArgumentError) { instance.create_and_upload_feed_document(Object.new, content_type: "text/xml") }
    assert_raises(ArgumentError) { instance.create_and_upload_feed_document("x", content_type: "text/xml", content_length: -1) }
    assert_raises(ArgumentError) { instance.create_and_upload_feed_document("x", content_type: "text/xml", bogus: 1) }
  end

  def test_upload_rejection_is_returned_and_failure_retains_the_document_id
    route_server(feed_handler(upload_status: 403, upload_body: "upload denied")) do |url, requests|
      uploaded = client(url).create_and_upload_feed_document("x", content_type: "text/xml", max_response_bytes: 6)

      assert_equal("fd/1", uploaded.document_id)
      assert_equal(403, uploaded.response.status)
      assert_equal("upload", uploaded.response.body)
      assert_predicate(uploaded.response, :body_truncated?)
      assert_equal(2, requests.call.size, "neither mutation retried")
    end
    route_server(feed_handler) do |url, _|
      error = assert_raises(Peddler::DocumentError) { client(url).create_and_upload_feed_document("abc", content_type: "text/xml", content_length: 5) }

      assert_equal("fd/1", error.document_id)
      refute_match(/SIGNED_SECRET/, error.full_message(highlight: false))
      source_error = RuntimeError.new("private-secret")
      source = Object.new
      source.define_singleton_method(:read) { |_| raise source_error }
      error = assert_raises(Peddler::DocumentError) { client(url).create_and_upload_feed_document(source, content_type: "text/xml") }

      assert_equal("fd/1", error.document_id)
      assert_same(source_error, error.cause)
      refute_match(/private-secret/, error.message)
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
