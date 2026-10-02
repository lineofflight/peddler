# frozen_string_literal: true

require_relative "test_helper"
require "stringio"

# rubocop:disable Minitest/MultipleAssertions
class WorkflowsTest < NativeTest
  GZIP = [
    31, 139, 8, 0, 0, 0, 0, 0, 2, 255, 171, 86, 170, 80, 178, 50, 172, 229, 2, 0, 21, 240, 49, 80, 8, 0, 0, 0,
  ].pack("C*")

  # Loopback server with the shared fixture's deadlines: 5s per connection, 10s of accepting.
  # The handler receives the socket, request line parts, headers, body and base URL. Every
  # request is logged as [path, headers, body, verb].
  def route_server(handler)
    listener = TCPServer.new("127.0.0.1", 0)
    base = "http://127.0.0.1:#{listener.addr[1]}"
    log = []
    lock = Mutex.new
    workers = []
    stopping = false
    acceptor = Thread.new do
      accept_deadline = Process.clock_gettime(Process::CLOCK_MONOTONIC) + 10
      until stopping || Process.clock_gettime(Process::CLOCK_MONOTONIC) > accept_deadline
        next unless listener.wait_readable(0.1)

        workers << Thread.new(listener.accept) do |connection|
          Timeout.timeout(5) do
            request_line = connection.gets("\r\n")
            next unless request_line

            first = request_line.split
            headers = {}
            while (line = connection.gets("\r\n")) != "\r\n"
              key, value = line.split(":", 2)
              headers[key.downcase] = value.strip
            end
            body = connection.read(headers.fetch("content-length", "0").to_i)
            lock.synchronize { log << [first[1], headers, body, first[0]] }
            handler.call(connection, first, headers, body, base)
          end
        rescue Errno::EPIPE, Errno::ECONNRESET
          nil
        ensure
          connection.close
        end
      end
    rescue IOError, Errno::EBADF
      nil
    end
    yield(base, -> { lock.synchronize { log.dup } })
  ensure
    stopping = true
    acceptor&.join(2)
    acceptor&.kill
    workers&.each(&:kill)
    workers&.each(&:join)
    listener&.close
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
    handler = lambda do |socket, first, _headers, _body, base|
      first[1].start_with?("/signed") ? respond(socket, body: "report body") : respond(socket, body: report_document(base))
    end
    route_server(handler) do |url, requests|
      document = client(url).download_report_document("a/b c")

      assert_equal("report body", document.each_chunk.to_a.join)
      metadata, signed = requests.call

      assert_equal("/reports/2021-06-30/documents/a%2Fb%20c", metadata[0])
      assert_equal("local-secret", metadata[1]["x-amz-access-token"])
      assert_equal("/signed?sig=SIGNED_SECRET", signed[0])
      refute(signed[1].key?("x-amz-access-token"))
    end
  end

  def test_gzip_metadata_decodes_with_and_without_the_header_exactly_once
    [[], [["Content-Encoding", "gzip"]]].each do |headers|
      handler = lambda do |socket, first, _, _, base|
        first[1].start_with?("/signed") ? respond(socket, headers: headers, body: GZIP) : respond(socket, body: report_document(base, algorithm: "GZIP"))
      end
      route_server(handler) do |url, _|
        rows = client(url).download_report_document("d1").each_jsonl.to_a

        assert_equal([{ "x" => 1 }], rows, headers.inspect)
      end
    end
  end

  def test_feed_and_query_documents_use_their_operations
    handler = lambda do |socket, first, _, _, base|
      case first[1]
      when "/signed" then respond(socket, headers: [["Content-Encoding", "gzip"]], body: GZIP)
      when %r{\A/feeds/} then respond(socket, body: JSON.generate(feedDocumentId: "f1", url: "#{base}/signed"))
      else respond(socket, body: JSON.generate(documentId: "k1", documentUrl: "#{base}/signed"))
      end
    end
    route_server(handler) do |url, requests|
      instance = client(url)

      assert_equal("{\"x\":1}\n", instance.download_feed_document("f1").each_chunk.to_a.join)
      assert_equal([{ "x" => 1 }], instance.download_query_document("k/1") { |document| document.each_jsonl.to_a })
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
      handler = lambda do |socket, first, _, _, base|
        flunk("downloaded") if first[1].start_with?("/signed")
        respond(socket, body: body.gsub("http://x", base))
      end
      route_server(handler) do |url, requests|
        error = assert_raises(error_class, name.to_s) { client(url).download_report_document("d1", **options) }

        refute_match(/SIGNED_SECRET|127\.0\.0\.1/, error.full_message(highlight: false), name.to_s)
        assert_equal(1, requests.call.size, name.to_s)
      end
    end
  end

  def test_metadata_http_error_raises_the_api_error_with_the_raw_response
    handler = lambda { |socket, *|
      respond(socket, status: 404, headers: [["x-amzn-requestid", "request-id"]],
        body: '{"errors":[{"code":"NotFound","message":"Amazon says no"}]}')
    }
    route_server(handler) do |url, requests|
      error = assert_raises(Peddler::Error) { client(url).download_feed_document("d1") }

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
    assert_raises(ArgumentError) { instance.download_report_document("") }
    assert_raises(ArgumentError) { instance.download_report_document(nil) }
    assert_raises(ArgumentError) { instance.download_report_document("d1", max_bytes: 0) }
    assert_raises(ArgumentError) { instance.download_report_document("d1", bogus: 1) }
    [0, -1, Float::NAN, Float::INFINITY, "5", nil].each do |value|
      assert_raises(ArgumentError, value.inspect) { instance.wait_for_report("r1", interval: value) }
      assert_raises(ArgumentError, value.inspect) { instance.wait_for_feed("f1", timeout: value) }
    end
    assert_raises(ArgumentError) { instance.wait_for_query("") }
  end

  def test_transfer_non_success_keeps_download_semantics_and_limits
    handler = lambda do |socket, first, _, _, base|
      first[1].start_with?("/signed") ? respond(socket, status: 403, body: "signed denial") : respond(socket, body: report_document(base))
    end
    route_server(handler) do |url, _|
      document = client(url).download_report_document("d1", max_response_bytes: 6)

      assert_equal(403, document.status)
      assert_equal("signed", document.error_body)
      assert_predicate(document, :error_body_truncated?)
    end
  end

  def test_wait_polls_until_done_with_integer_and_float_options
    statuses = %w[IN_QUEUE IN_PROGRESS DONE]
    count = 0
    handler = lambda do |socket, *|
      respond(socket, body: report(statuses[[count, 2].min]))
      count += 1
    end
    route_server(handler) do |url, requests|
      response = client(url).wait_for_report("r/1", interval: 0.05, timeout: 5)

      assert_equal("DONE", response.json.fetch("processingStatus"))
      assert_equal("d9", response.json.fetch("reportDocumentId"))
      assert_equal(200, response.status)
      assert_equal(["/reports/2021-06-30/reports/r%2F1"] * 3, requests.call.map(&:first))
    end
  end

  def test_wait_returns_fatal_cancelled_feed_and_query_ids
    %w[FATAL CANCELLED].each do |status|
      handler = ->(socket, *) { respond(socket, body: report(status)) }
      route_server(handler) do |url, _|
        response = client(url).wait_for_report("r1", interval: 0.01, timeout: 2)

        assert_equal(status, response.json.fetch("processingStatus"))
        assert_equal("d9", response.json.fetch("reportDocumentId"))
      end
    end
    handler = lambda do |socket, first, *|
      if first[1].include?("/feeds/")
        respond(socket, body: JSON.generate(feedId: "f1", feedType: "T", processingStatus: "FATAL", createdTime: "2024-01-01T00:00:00Z", resultFeedDocumentId: "rf"))
      else
        respond(socket, body: JSON.generate(queryId: "q1", query: "x", processingStatus: "DONE", createdTime: "2024-01-01T00:00:00Z", dataDocumentId: "dd", errorDocumentId: "ed"))
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
    route_server(->(socket, *) { respond(socket, body: report("SOMETHING_NEW")) }) do |url, requests|
      error = assert_raises(Peddler::WorkflowError) { client(url).wait_for_report("r1", interval: 0.01, timeout: 2) }

      refute_match(/SOMETHING_NEW/, error.message)
      assert_equal(1, requests.call.size)
    end
    route_server(->(socket, *) { respond(socket, status: 429, body: '{"errors":[]}') }) do |url, requests|
      error = assert_raises(Peddler::Error) { client(url).wait_for_report("r1", interval: 0.01, timeout: 2) }

      assert_equal(429, error.status)
      assert_equal(429, error.response.status)
      assert_equal(1, requests.call.size)
    end
    route_server(->(socket, *) { respond(socket, body: '{"processingStatus":1}') }) do |url, _|
      assert_raises(Peddler::WorkflowError) { client(url).wait_for_report("r1", interval: 0.01, timeout: 2) }
    end
  end

  def test_wait_is_bounded_and_no_polls_follow_the_deadline
    route_server(->(socket, *) { respond(socket, body: report("IN_QUEUE")) }) do |url, requests|
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      assert_raises(Peddler::WorkflowTimeoutError) { client(url).wait_for_report("r1", interval: 0.04, timeout: 0.25) }
      elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started

      assert_operator(elapsed, :>=, 0.24)
      assert_operator(elapsed, :<, 0.7)
      polls = requests.call.size

      assert_includes(5..7, polls)
      sleep(0.2)

      assert_equal(polls, requests.call.size)
    end
    route_server(->(socket, *) { sleep(2) && respond(socket, body: report("DONE")) }) do |url, _|
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      assert_raises(Peddler::WorkflowTimeoutError) { client(url).wait_for_report("r1", interval: 0.01, timeout: 0.2) }

      assert_operator(Process.clock_gettime(Process::CLOCK_MONOTONIC) - started, :<, 0.7)
    end
  end

  def test_thread_kill_releases_the_gvl_stops_polling_and_the_client_recovers
    polls = Queue.new
    status = "IN_PROGRESS"
    handler = lambda do |socket, *|
      polls << true
      respond(socket, body: report(status))
    end
    route_server(handler) do |url, requests|
      instance = client(url)
      thread = Thread.new { instance.wait_for_report("r1", interval: 0.02, timeout: 30) }
      thread.report_on_exception = false
      # A wait that dies before polling fails here with its own error instead of hanging.
      polled = nil
      50.times do
        break if (polled = polls.pop(timeout: 0.1))

        thread.value unless thread.alive?
      end

      assert(polled, "wait never polled")
      ticks = 0
      ticker = Thread.new do
        20.times do
          ticks += 1
          sleep(0.001)
        end
      end
      ticker.join
      thread.kill

      assert(thread.join(1), "interrupted wait must return")
      assert_equal(20, ticks)
      sleep(0.05)
      stopped = requests.call.size
      sleep(0.2)

      assert_equal(stopped, requests.call.size)

      status = "DONE"
      response = instance.wait_for_report("r1", interval: 0.01, timeout: 2)

      assert_equal("DONE", response.json.fetch("processingStatus"))
    end
  end

  def test_one_total_timeout_covers_metadata_and_transfer
    handler = lambda do |socket, first, _, _, base|
      if first[1].start_with?("/signed")
        socket.write("HTTP/1.1 200 OK\r\nContent-Length: 100\r\n\r\npartial")
        sleep(3)
      else
        sleep(0.3)
        respond(socket, body: report_document(base))
      end
    end
    route_server(handler) do |url, _|
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      document = client(url).download_report_document("d1", timeout: 0.6)
      assert_raises(Peddler::DocumentTimeoutError) { document.each_chunk.to_a }
      elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started

      assert_operator(elapsed, :>=, 0.55)
      assert_operator(elapsed, :<, 0.9)
      assert_raises(Peddler::WorkflowTimeoutError) { client(url).download_report_document("d1", timeout: 0.1) }
    end
  end

  def feed_handler(upload_status: 200, upload_body: "", **options)
    lambda do |socket, first, _headers, _body, base|
      if first[1].start_with?("/signed")
        respond(socket, status: upload_status, body: upload_body)
      else
        respond(socket, status: options.fetch(:create_status, 201), body: options.fetch(:create_body) { JSON.generate(feedDocumentId: "fd/1", url: "#{base}/signed?sig=SIGNED_SECRET") })
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

  def test_upload_source_and_total_timeout_share_one_deadline
    handler = lambda do |socket, first, _, _, base|
      if first[1].start_with?("/signed")
        sleep(2)
        respond(socket)
      else
        sleep(0.3)
        respond(socket, status: 201, body: JSON.generate(feedDocumentId: "fd1", url: "#{base}/signed"))
      end
    end
    route_server(handler) do |url, _|
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      error = assert_raises(Peddler::DocumentTimeoutError) { client(url).create_and_upload_feed_document("x", content_type: "text/xml", timeout: 0.6) }
      elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started

      assert_equal("fd1", error.document_id)
      assert_operator(elapsed, :>=, 0.55)
      assert_operator(elapsed, :<, 0.9)
    end
  end

  def test_inherited_engine_is_guarded_for_every_workflow_entry_point
    instance = client("http://127.0.0.1:1")
    reader, writer = IO.pipe
    pid = fork do
      reader.close
      guarded = [
        -> { instance.download_report_document("d") },
        -> { instance.download_feed_document("d") },
        -> { instance.download_query_document("d") },
        -> { instance.wait_for_report("r") },
        -> { instance.wait_for_feed("f") },
        -> { instance.wait_for_query("q") },
        -> { instance.create_and_upload_feed_document("x", content_type: "text/xml") },
      ].all? do |call|
        call.call
        false
      rescue Peddler::ForkError
        true
      end
      writer.write(guarded ? "guarded" : "failed")
      writer.close
      exit!(0)
    end
    writer.close

    assert_equal("guarded", Timeout.timeout(5) { reader.read })
    Process.wait(pid)
    reader.close
  end
end
# rubocop:enable Minitest/MultipleAssertions
