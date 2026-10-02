# frozen_string_literal: true

require_relative "test_helper"
require "zlib"
require "stringio"
require "bigdecimal"

# rubocop:disable Minitest/MultipleAssertions
class DocumentsTest < NativeTest
  def chunked(socket, chunks, headers: [])
    socket.write("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\nConnection: close\r\n")
    headers.each { |key, value| socket.write("#{key}: #{value}\r\n") }
    socket.write("\r\n")
    chunks.each { |chunk| socket.write("#{chunk.bytesize.to_s(16)}\r\n#{chunk}\r\n") }
    socket.write("0\r\n\r\n")
  end

  def test_download_gzip_query_metadata_and_binary_chunks_after_parent_gc
    buffer = StringIO.new
    gzip = Zlib::GzipWriter.new(buffer)
    gzip.write("hello\xFF".b)
    gzip.close
    serve(handler: lambda { |socket, first, headers, _|
      assert_equal("/file?a=%2f&b=+&a=%2F", first[1])
      refute(headers.key?("x-amz-access-token"))
      chunked(socket, buffer.string.bytes.each_slice(3).map { |bytes| bytes.pack("C*") }, headers: [["Content-Encoding", "gzip"], ["x-repeat", "a"], ["x-repeat", "b"]])
    }) do |url|
      instance = client(url)
      document = instance.download_document("#{url}/file?a=%2f&b=+&a=%2F", compression: :gzip)
      instance = nil
      GC.start

      assert_equal(200, document.status)
      assert_equal([["x-repeat", "a"], ["x-repeat", "b"]], document.headers.select { |key, _| key == "x-repeat" })
      chunks = document.each_chunk.to_a

      assert_equal("hello\xFF".b, chunks.join)
      assert(chunks.all? { |chunk| chunk.encoding == Encoding::BINARY })
      assert_predicate(document, :closed?)
      refute_match(/file|%2f/, document.inspect)
    end
  end

  def test_jsonl_null_large_integer_and_exact_decimal_across_chunks
    serve(handler: ->(socket, *) { chunked(socket, ["null\n{\"n\":123456789012345678901234567890,", '"d":0.12345678901234567890123456789}', "\n\"é\"".byteslice(0, 3), "\n\"é\"".byteslice(3..)]) }) do |url|
      rows = client(url).download_document(url).each_jsonl.to_a

      assert_nil(rows[0])
      assert_equal(123456789012345678901234567890, rows[1].fetch("n"))
      assert_equal(BigDecimal("0.12345678901234567890123456789"), rows[1].fetch("d"))
      assert_equal("é", rows[2])
    end
  end

  def test_quoted_tsv_and_bounded_json
    serve(count: 2, handler: lambda { |socket, first, *_|
      if first[1] == "/tsv"
        chunked(socket, ["\"a\t", "b\"\t\"line\n", "next\"\r\n\"é\"\tx\n"])
      else
        respond(socket, body: '{"number":123456789012345678901234567890}')
      end
    }) do |url|
      instance = client(url)

      assert_equal([["a\tb", "line\nnext"], ["é", "x"]], instance.download_document("#{url}/tsv").each_tsv(consistent_fields: true).to_a)
      document = instance.download_document("#{url}/json")
      assert_raises(Peddler::Native::DocumentError) { document.json(max_bytes: 3) }
      assert_predicate(document, :closed?)
    end
  end

  def test_non_success_raw_bounded_body_and_redirect_suppression
    serve(handler: ->(socket, *) { respond(socket, status: 302, headers: [["Location", "http://127.0.0.1:1/private-secret"]], body: "\xFF\x00abc".b) }) do |url|
      document = client(url).download_document(url, max_response_bytes: 2)

      assert_equal(302, document.status)
      assert_equal("\xFF\x00".b, document.error_body)
      assert_predicate(document, :error_body_truncated?)
      assert_equal("\xFF\x00".b, document.each_chunk.to_a.join)
    end
  end

  def test_invalid_options_and_format_errors_are_sanitized
    instance = client("http://127.0.0.1:1")
    [{ unknown_secret: 1 }, { compression: "gzip" }, { timeout: 0 }, { max_bytes: 0 }, { max_records: 1.5 }].each do |options|
      error = assert_raises(ArgumentError) { instance.download_document("https://example.com/private-secret", **options) }
      refute_match(/private-secret|unknown_secret/, error.message)
    end
    serve(handler: ->(socket, *) { respond(socket, body: 'private-secret invalid JSON') }) do |url|
      error = assert_raises(Peddler::Native::DocumentError) { client(url).download_document(url).each_jsonl.to_a }
      refute_match(/private-secret/, error.message)
    end
  end

  def test_mode_reuse_and_early_break_close_socket
    serve(handler: lambda { |socket, *|
      socket.write("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n4\r\nrow\n\r\n")

      assert_nil(socket.read(1))
    }) do |url|
      document = client(url).download_document(url)
      document.each_chunk { break }

      assert_predicate(document, :closed?)
      assert_raises(Peddler::Native::DocumentError) { document.each_jsonl.to_a }
    end
  end

  def test_block_and_iterator_exceptions_close_socket
    serve(count: 2, handler: lambda { |socket, *|
      socket.write("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n4\r\nrow\n\r\n")

      assert_nil(socket.read(1))
    }) do |url|
      document = nil
      assert_raises(RuntimeError) do
        client(url).download_document(url) do |stream|
          document = stream
          raise "caller error"
        end
      end
      assert_predicate(document, :closed?)
      stream = client(url).download_document(url)
      assert_raises(RuntimeError) { stream.each_chunk { raise "caller error" } }
      assert_predicate(stream, :closed?)
    end
  end

  def raw_server(count: 1, handler:)
    server = TCPServer.new("127.0.0.1", 0)
    workers = []
    acceptor = Thread.new do
      count.times do
        raise "accept deadline" unless server.wait_readable(5)
        socket = server.accept
        workers << Thread.new(socket) do |connection|
          Timeout.timeout(5) do
            line = connection.gets("\r\n")
            next unless line # A failed body can close before HTTP headers are sent.
            first = line.split
            headers = {}
            while (line = connection.gets("\r\n")) != "\r\n"
              key, value = line.split(":", 2)
              headers[key.downcase] = value.strip
            end
            handler.call(connection, first, headers)
          end
        ensure
          connection.close
        end
      end
      workers.each(&:value)
    end
    yield "http://127.0.0.1:#{server.addr[1]}"
    raise "server deadline" unless acceptor.join(6)
    acceptor.value
  ensure
    acceptor&.kill
    workers&.each(&:kill)
    workers&.each(&:join)
    acceptor&.join
    server&.close
  end

  def test_upload_string_and_io_exact_content_type_headers_and_bounded_reads
    payload = "a\xFFb".b * 50_000
    reads = []
    io = StringIO.new(payload)
    io.define_singleton_method(:read) do |length|
      reads << length
      super(length)
    end
    serve(count: 2, handler: lambda { |socket, first, headers, body|
      assert_equal("PUT", first[0])
      assert_equal("text/xml; charset=UTF-8", headers.fetch("content-type"))
      assert_equal("signed", headers.fetch("x-signed"))
      refute(headers.key?("x-amz-access-token"))
      assert_equal(payload, body)
      respond(socket, status: 400, headers: [["x-repeat", "a"], ["x-repeat", "b"]], body: "reply-too-long")
    }) do |url|
      instance = client(url)
      [payload, io].each do |source|
        response = instance.upload_document(url, source, content_type: "text/xml; charset=UTF-8", headers: { "x-signed" => "signed" }, content_length: payload.bytesize, max_response_bytes: 5)

        assert_equal(400, response.status)
        assert_equal("reply", response.body)
        assert_predicate(response, :body_truncated?)
        assert_equal("client", assert_raises(Peddler::Native::APIError) { response.raise_for_status! }.kind)
      end
    end

    assert_operator(reads.size, :>=, 4)
    assert(reads.all?(64 * 1024))
  end

  def test_upload_unknown_length_streams_chunked_body
    raw_server(handler: lambda { |socket, _first, headers|
      assert_equal("chunked", headers.fetch("transfer-encoding"))
      body = +"".b
      loop do
        length = socket.gets("\r\n").to_i(16)
        break if length.zero?
        body << socket.read(length)

        assert_equal("\r\n", socket.read(2))
      end
      assert_equal("\r\n", socket.read(2))
      assert_equal("unknown-length", body)
      respond(socket)
    }) do |url|
      assert_equal(200, client(url).upload_document(url, StringIO.new("unknown-length"), content_type: "text/plain").status)
    end
  end

  def test_upload_early_rejection_does_not_deadlock_or_read_entire_source
    reads = 0
    source = Object.new
    source.define_singleton_method(:read) do |length|
      reads += 1
      "a" * length
    end
    raw_server(handler: lambda { |socket, *_|
      respond(socket, status: 413, body: "rejected")
      socket.read # Drain queued bytes so TCP close cannot erase the reply.
    }) do |url|
      response = Timeout.timeout(3) { client(url).upload_document(url, source, content_type: "text/plain", content_length: 64 * 1024 * 1024) }

      assert_equal(413, response.status)
      assert_equal("rejected", response.body)
    end
    assert_operator(reads, :<, 128)
  end

  def test_upload_length_mismatch_and_source_exception_are_sanitized
    raw_server(count: 3, handler: lambda { |socket, *_|
      begin
        socket.read
      rescue Errno::ECONNRESET
        nil
      end
    }) do |url|
      instance = client(url)
      [2, 4].each do |length|
        error = assert_raises(Peddler::Native::DocumentError) { instance.upload_document(url, "abc", content_type: "text/plain", content_length: length) }
        assert_match(/length mismatch/, error.message)
      end
      source_exception = RuntimeError.new("private-secret IO URL")
      source = Object.new
      source.define_singleton_method(:read) do |_|
        sleep(0.02)
        raise source_exception
      end
      error = assert_raises(Peddler::Native::DocumentError) { instance.upload_document(url, source, content_type: "text/plain") }
      refute_match(/private-secret/, error.message)
      assert_same(source_exception, error.cause)
    end
  end

  def test_stream_interrupt_releases_gvl_closes_socket_and_new_transfer_works
    started = Queue.new
    serve(count: 2, handler: lambda { |socket, first, *_|
      if first[1] == "/blocked"
        socket.write("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n")
        started << true

        assert_nil(socket.read(1))
      else
        respond(socket, body: "second")
      end
    }) do |url|
      instance = client(url)
      stream = instance.download_document("#{url}/blocked")
      thread = Thread.new { stream.each_chunk.to_a }
      started.pop
      ticks = 0
      ticker = Thread.new {
                 20.times {
                              ticks += 1
                              sleep(0.001) } }
      ticker.join
      thread.kill

      assert(thread.join(1), "interrupted native read must return")
      assert_predicate(stream, :closed?)
      assert_equal(20, ticks)
      assert_equal("second", instance.download_document(url).each_chunk.to_a.join)
    end
  end

  def test_inherited_stream_and_upload_are_guarded_and_child_client_works
    serve(count: 2, handler: ->(socket, *) { respond(socket, body: "child") }) do |url|
      stream = client(url).download_document(url)
      engine = client("http://127.0.0.1:1").instance_variable_get(:@engine)
      upload = engine.start_document_upload("http://127.0.0.1:1", "{}", "text/plain", [], nil)
      reader, writer = IO.pipe
      pid = fork do
        reader.close
        begin
          guarded = [:status, :headers, :error_body, :closed?, :close].all? do |method|
            stream.public_send(method)
            false
          rescue Peddler::Native::ForkError
            true
          end
          guarded &&= [:completed?, :finish, :close].all? do |method|
            upload.public_send(method)
            false
          rescue Peddler::Native::ForkError
            true
          end
          content = client(url).download_document(url).each_chunk.to_a.join
          stream = nil
          upload = nil
          GC.start
          writer.write(guarded && content == "child" ? "guarded-and-recovered" : "failed")
        ensure
          writer.close
        end
        exit!(0)
      end
      writer.close

      assert_equal("guarded-and-recovered", Timeout.timeout(3) { reader.read })
      Process.wait(pid)
      reader.close
      stream.close
      upload.close
    end
  end

  def test_concurrent_read_fails_and_close_cancels_the_active_socket
    started = Queue.new
    serve(handler: lambda { |socket, *_|
      socket.write("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n")

      assert_nil(socket.read(1))
    }) do |url|
      stream = client(url).download_document(url)
      thread = Thread.new do
        started << true
        begin
          stream.each_chunk.to_a
        rescue Peddler::Native::DocumentError
          :closed
        end
      end
      started.pop
      Thread.pass until thread.status == "sleep"
      assert_raises(Peddler::Native::DocumentError) { stream.each_jsonl.to_a }
      assert(thread.join(1), "close must cancel the active stream")
      assert_equal(:closed, thread.value)
      assert_predicate(stream, :closed?)
    ensure
      thread&.kill
      thread&.join
    end
  end

  def test_absolute_stream_timeout_and_second_transfer
    serve(count: 2, handler: lambda { |socket, first, *_|
      if first[1] == "/slow"
        socket.write("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n4\r\nrow\n\r\n")

        assert_nil(socket.read(1))
      else
        respond(socket, body: "recovered")
      end
    }) do |url|
      instance = client(url)
      stream = instance.download_document("#{url}/slow", timeout: 0.03)
      assert_raises(Peddler::Native::DocumentTimeoutError) { stream.each_chunk { sleep(0.05) } }
      assert_predicate(stream, :closed?)
      assert_equal("recovered", instance.download_document(url).each_chunk.to_a.join)
    end
  end

  def test_upload_thread_kill_and_timeout_abort_sockets_then_recover
    [false, true].each do |timeout|
      started = Queue.new
      source = Object.new
      source.define_singleton_method(:read) do |length|
        started << true
        sleep(1)
        "a" * length
      end
      raw_server(count: 2, handler: lambda { |socket, first, *_|
        if first[1] == "/blocked"
          assert_nil(socket.read(1))
        else
          # The successful body is deliberately empty.
          respond(socket)
        end
      }) do |url|
        instance = client(url)
        thread = Thread.new do
          instance.upload_document("#{url}/blocked", source, content_type: "text/plain", timeout: timeout ? 0.03 : 30)
        rescue Peddler::Native::DocumentTimeoutError
          :timed_out
        end
        started.pop
        if timeout
          assert(thread.join(2))
          assert_equal(:timed_out, thread.value)
        else
          sleep(0.02)
          thread.kill

          assert(thread.join(1))
        end

        assert_equal(200, instance.upload_document(url, "", content_type: "text/plain", content_length: 0).status)
      ensure
        thread&.kill
        thread&.join
      end
    end
  end

  def test_native_upload_close_and_repeated_finish_do_not_wait_forever
    instance = client("http://127.0.0.1:1")
    engine = instance.instance_variable_get(:@engine)
    upload = engine.start_document_upload("http://127.0.0.1:1", "{}", "text/plain", [], nil)
    upload.close
    assert_raises(Peddler::Native::DocumentError) { Timeout.timeout(1) { upload.finish } }
    assert_raises(Peddler::Native::DocumentError) { Timeout.timeout(1) { upload.finish } }
  end

  def test_io_upload_backpressure_bounds_reads_until_server_consumes
    started = Queue.new
    release = Queue.new
    reads = 0
    remaining = 16 * 1024 * 1024
    source = Object.new
    source.define_singleton_method(:read) do |length|
      reads += 1
      next nil if remaining.zero?
      size = [remaining, length].min
      remaining -= size
      "a" * size
    end
    serve_raw_upload = lambda do |socket, _first, headers|
      started << true
      release.pop
      received = 0
      while received < headers.fetch("content-length").to_i
        chunk = socket.read([64 * 1024, headers.fetch("content-length").to_i - received].min)
        received += chunk.bytesize
      end

      assert_equal(16 * 1024 * 1024, received)
      respond(socket)
    end
    raw_server(handler: serve_raw_upload) do |url|
      thread = Thread.new { client(url).upload_document(url, source, content_type: "text/plain", content_length: 16 * 1024 * 1024) }
      started.pop
      sleep(0.05)

      assert_operator(reads, :<, 128, "server backpressure must prevent reading all 256 chunks")
      release << true

      assert_equal(200, thread.value.status)
      assert_equal(257, reads) # EOF lookahead remains required at Content-Length.
    ensure
      release << true
      thread&.kill
      thread&.join
    end
  end

  def test_bounded_whole_json_preserves_numbers_and_rust_limits_map_to_document_errors
    serve(count: 5, handler: lambda { |socket, first, *_|
      body = case first[1]
      when "/json" then '{"n":123456789012345678901234567890,"d":0.12345678901234567890123456789}'
      when "/rows" then "null\nnull\n"
      when "/utf8" then "\xFF\tx\n".b
      else "abcd"
      end
      respond(socket, body: body)
    }) do |url|
      instance = client(url)
      value = instance.download_document("#{url}/json").json(max_bytes: 100)

      assert_equal(123456789012345678901234567890, value.fetch("n"))
      assert_equal(BigDecimal("0.12345678901234567890123456789"), value.fetch("d"))
      assert_raises(Peddler::Native::DocumentError) { instance.download_document("#{url}/bytes", max_bytes: 3).each_chunk.to_a }
      assert_raises(Peddler::Native::DocumentError) { instance.download_document("#{url}/record", max_record_bytes: 3).each_jsonl.to_a }
      assert_raises(Peddler::Native::DocumentError) { instance.download_document("#{url}/rows", max_records: 1).each_jsonl.to_a }
      assert_raises(Peddler::Native::DocumentError) { instance.download_document("#{url}/utf8").each_tsv.to_a }
    end
  end

  def test_mode_switch_while_iterator_yields_is_rejected
    serve(handler: ->(socket, *) { respond(socket, body: "chunk") }) do |url|
      document = client(url).download_document(url)
      document.each_chunk do
        assert_raises(Peddler::Native::DocumentError) { document.each_jsonl.to_a }
        break
      end

      assert_predicate(document, :closed?)
    end
  end

  def test_thread_kill_while_native_upload_waits_for_backpressure_releases_socket
    started = Queue.new
    source = Object.new
    source.define_singleton_method(:read) { |length| "a" * length }
    raw_server(count: 2, handler: lambda { |socket, first, *_|
      if first[1] == "/blocked"
        started << true
        sleep(0.1)
        # Drain only after cancellation; EOF confirms worker/socket cleanup.
        socket.read
      else
        respond(socket)
      end
    }) do |url|
      instance = client(url)
      thread = Thread.new { instance.upload_document("#{url}/blocked", source, content_type: "text/plain") }
      started.pop
      sleep(0.05)
      thread.kill

      assert(thread.join(1), "bounded native push must be interruptible")
      assert_equal(200, instance.upload_document(url, "", content_type: "text/plain", content_length: 0).status)
    ensure
      thread&.kill
      thread&.join
    end
  end

  def test_decimal_exponent_overflow_and_underflow_do_not_silently_lose_precision
    serve(count: 2, handler: lambda { |socket, first, *_|
      body = first[1] == "/overflow" ? '{"secret":1e999999999999999999999999999999999}' : '{"secret":1e-999999999999999999999999999999999}'
      respond(socket, body: body)
    }) do |url|
      instance = client(url)
      ["overflow", "underflow"].each do |path|
        error = assert_raises(Peddler::Native::DocumentError) { instance.download_document("#{url}/#{path}").each_jsonl.to_a }
        refute_match(/secret|999999/, error.message)
      end
    end
  end

  def sensitive_rescue
    raise "signed-url-header-body-secret"
  rescue RuntimeError => sensitive
    yield sensitive
  end

  def test_download_document_invalid_url_encoding
    instance = client("http://127.0.0.1:1")
    error = assert_raises(ArgumentError) { instance.download_document("http://127.0.0.1:1/\xFF") }
    assert_equal("invalid document URL", error.message)
  end

  def test_upload_document_overflow_content_length
    instance = client("http://127.0.0.1:1")
    error = assert_raises(ArgumentError) { instance.upload_document("http://127.0.0.1:1", "x", content_type: "text/plain", content_length: 1 << 70) }
    assert_equal("invalid document upload configuration", error.message)
  end

  def test_upload_document_invalid_header_encoding
    instance = client("http://127.0.0.1:1")
    error = assert_raises(ArgumentError) { instance.upload_document("http://127.0.0.1:1", "x", content_type: "text/plain", headers: { "x-a" => "\xFF" }) }
    assert_equal("invalid document upload configuration", error.message)
  end

  def test_upload_document_invalid_content_type_encoding
    instance = client("http://127.0.0.1:1")
    error = assert_raises(ArgumentError) { instance.upload_document("http://127.0.0.1:1", "x", content_type: "\xFF") }
    assert_equal("invalid document upload configuration", error.message)
  end

  def test_document_json_overflow_max_bytes
    serve(handler: ->(socket, *) { respond(socket, body: "{}") }) do |url|
      document = client(url).download_document(url)
      error = assert_raises(ArgumentError) { document.json(max_bytes: 1 << 70) }
      assert_equal("invalid document configuration", error.message)
    end
  end

  def test_invalid_url_and_out_of_range_limit
    instance = client("http://127.0.0.1:1")
    error = assert_raises(ArgumentError) { instance.download_document("bad-url") }
    assert_equal("invalid document URL", error.message)
    error = assert_raises(ArgumentError) { instance.download_document("https://example.com/private", max_bytes: 1 << 65) }
    assert_equal("invalid document configuration", error.message)
    error = assert_raises(ArgumentError) { instance.upload_document("bad-url", "", content_type: "text/plain") }
    assert_equal("invalid document URL", error.message)
  end

  def test_caller_block_exceptions_retain_identity_and_active_causes
    serve(count: 2, handler: ->(socket, *) { respond(socket, body: "chunk") }) do |url|
      sensitive_rescue do |sensitive|
        caller_error = ArgumentError.new("caller error")
        caught = assert_raises(ArgumentError) { client(url).download_document(url) { raise caller_error } }
        assert_same(caller_error, caught)
        assert_same(sensitive, caught.cause)
        document = client(url).download_document(url)
        row_error = Peddler::Native::DocumentError.new("caller row error")
        caught = assert_raises(Peddler::Native::DocumentError) { document.each_chunk { raise row_error } }
        assert_same(row_error, caught)
        assert_same(sensitive, caught.cause)
        assert_predicate(document, :closed?)
      end
    end
  end

  def test_thread_raise_during_read_preserves_original_exception
    started = Queue.new
    serve(handler: lambda { |socket, *_|
      socket.write("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n")
      started << true

      assert_nil(socket.read(1))
    }) do |url|
      document = client(url).download_document(url)
      thread = Thread.new do
        sensitive_rescue { document.each_chunk.to_a }
      rescue Peddler::Native::DocumentError => error
        error
      end
      started.pop
      Thread.pass until thread.status == "sleep"
      original = Peddler::Native::DocumentError.new("caller interruption")
      thread.raise(original)

      assert(thread.join(1))
      assert_same(original, thread.value)
      assert_predicate(document, :closed?)
    ensure
      thread&.kill
      thread&.join
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
