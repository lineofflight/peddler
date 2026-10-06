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

  def test_download_gzip_query_headers_and_binary_chunks
    buffer = StringIO.new
    gzip = Zlib::GzipWriter.new(buffer)
    gzip.write("hello\xFF".b)
    gzip.close
    serve(handler: lambda { |socket, first, headers, _|
      assert_equal("/file?a=%2f&b=+&a=%2F", first[1])
      refute(headers.key?("x-amz-access-token"))
      refute(headers.key?("x-amz-date"))
      assert_equal(hostless_user_agent, headers["user-agent"])
      chunked(socket, buffer.string.bytes.each_slice(3).map { |bytes| bytes.pack("C*") }, headers: [["Content-Encoding", "gzip"], ["x-repeat", "a"], ["x-repeat", "b"]])
    }) do |url|
      document = client(url).download_document("#{url}/file?a=%2f&b=+&a=%2F", compression: :gzip)

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

  def test_jsonl_rows_keep_the_key_order_of_the_document
    body = %({"b":1,"a":{"z":1.50,"y":null},"A":[]}\r\n{"z":0,"a":0}\n{"k":1,"j":0,"k":2})
    serve(handler: ->(socket, *) { respond(socket, body: body) }) do |url|
      rows = client(url).download_document(url).each_jsonl.to_a

      assert_equal([["b", "a", "A"], ["z", "a"], ["k", "j"]], rows.map(&:keys))
      assert_equal(["z", "y"], rows[0].fetch("a").keys)
      assert_equal(BigDecimal("1.5"), rows[0].dig("a", "z"))
      assert_equal(Encoding::UTF_8, rows[0].keys.first.encoding)
      # A repeated key keeps its last value, as it did when the core parsed the row.
      assert_equal(2, rows[2].fetch("k"))
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

      assert_equal([["a\tb", "line\nnext"], ["é", "x"]], instance.download_document("#{url}/tsv").each_tsv.to_a)
      document = instance.download_document("#{url}/json")
      assert_raises(Peddler::DocumentError) { document.json(max_bytes: 3) }
      assert_predicate(document, :closed?)
    end
  end

  def test_rejected_download_raises_with_the_status_and_the_raw_response
    serve(handler: ->(socket, *) { respond(socket, status: 302, headers: [["Location", "http://127.0.0.1:1/elsewhere"]], body: "\xFF\x00abc".b) }) do |url|
      error = assert_raises(Peddler::Error) { client(url).download_document("#{url}/file?sig=SIGNED_SECRET") }

      assert_equal(302, error.status)
      assert_equal("\xFF\x00abc".b, error.response.body)
      assert_includes(error.response.headers, ["location", "http://127.0.0.1:1/elsewhere"])
      refute_match(/SIGNED_SECRET|127\.0\.0\.1/, error.message)
    end
  end

  def test_invalid_options_and_format_errors_are_sanitized
    instance = client("http://127.0.0.1:1")
    [{ unknown_secret: 1 }, { compression: "gzip" }, { timeout: 0 }, { max_bytes: 0 }, { max_record_bytes: 1.5 }, { max_bytes: 1 << 65 }].each do |options|
      error = assert_raises(ArgumentError) { instance.download_document("https://example.com/private-secret", **options) }
      refute_match(/private-secret|unknown_secret/, error.message)
    end
    assert_equal("invalid document URL", assert_raises(ArgumentError) { instance.download_document("https://example.com/\xFF") }.message)
    assert_equal("invalid document upload configuration",
      assert_raises(ArgumentError) { instance.upload_document("https://example.com", "x", content_type: "\xFF") }.message)
    serve(handler: ->(socket, *) { respond(socket, body: 'private-secret invalid JSON') }) do |url|
      error = assert_raises(Peddler::DocumentError) { client(url).download_document(url).each_jsonl.to_a }
      refute_match(/private-secret/, error.message)
    end
  end

  def test_early_break_and_exceptions_close_the_socket
    serve(count: 3, handler: lambda { |socket, *|
      socket.write("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n4\r\nrow\n\r\n")

      assert_nil(socket.read(1))
    }) do |url|
      document = client(url).download_document(url)
      document.each_chunk { break }

      assert_predicate(document, :closed?)
      assert_raises(Peddler::DocumentError) { document.each_jsonl.to_a }
      assert_raises(RuntimeError) do
        client(url).download_document(url) do |stream|
          document = stream
          raise "caller error"
        end
      end
      assert_predicate(document, :closed?)
      document = client(url).download_document(url)
      assert_raises(RuntimeError) { document.each_chunk { raise "caller error" } }
      assert_predicate(document, :closed?)
    end
  end

  CP1252 = "name\tprice\ncaf\xE9\t5\nm\xFCller\t\x805\n".b
  CP1252_ROWS = [["name", "price"], ["café", "5"], ["müller", "€5"]].freeze

  def read_tsv(chunks, content_type: nil, headers: [], **options)
    headers += [["Content-Type", content_type]] if content_type
    result = nil
    serve(handler: ->(socket, *) { chunked(socket, chunks, headers: headers) }) do |url|
      document = client(url).download_document(url)
      result = block_given? ? yield(document) : document.each_tsv(**options).to_a
    end
    result
  end

  def test_legacy_charset_labels_decode_to_utf8
    ["Cp1252", "ISO-8859-1", "windows-1252"].each do |label|
      rows = read_tsv([CP1252], content_type: "text/plain; charset=#{label}")

      assert_equal(CP1252_ROWS, rows, label)
      assert(rows.flatten.all? { |field| field.encoding == Encoding::UTF_8 && field.valid_encoding? })
    end
  end

  def test_charset_override_beats_header_and_missing_header
    assert_equal(CP1252_ROWS, read_tsv([CP1252], content_type: "text/plain; charset=utf-8", charset: "cp1252"))
    assert_equal(CP1252_ROWS, read_tsv([CP1252], charset: "Cp1252"))
    assert_raises(ArgumentError) { read_tsv([CP1252], charset: 1) }
  end

  def test_recorded_gzip_cp1252_report_replays
    body = File.binread(File.expand_path("../crates/peddler/tests/fixtures/cp1252_report.tsv.gz", __dir__))
    # The recorded body is ASCII only, so this proves the headers and the pipeline, not decoding.
    serve(handler: lambda { |socket, *|
      respond(socket, headers: [["Content-Type", "text/plain; charset=Cp1252"], ["Content-Encoding", "gzip"]], body: body)
    }) do |url|
      rows = client(url).download_document(url).each_tsv.to_a

      assert_equal(11, rows.size)
      assert_equal(["item-name", "item-description", "listing-id"], rows.first.first(3))
      assert_equal("SKU-001-TEST", rows[1][3])
    end
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
      refute(headers.key?("x-amz-date"))
      assert_equal(hostless_user_agent, headers["user-agent"])
      assert_equal(payload, body)
      respond(socket, headers: [["x-repeat", "a"], ["x-repeat", "b"]], body: "reply")
    }) do |url|
      instance = client(url)
      [payload, io].each do |source|
        response = instance.upload_document(url, source, content_type: "text/xml; charset=UTF-8", headers: { "x-signed" => "signed" }, content_length: payload.bytesize)

        assert_equal(200, response.status)
        assert_equal("reply", response.body)
        assert_equal([["x-repeat", "a"], ["x-repeat", "b"]], response.headers.select { |key, _| key == "x-repeat" })
      end
    end

    assert_operator(reads.size, :>=, 4)
    assert(reads.all?(64 * 1024))
  end

  def test_upload_unknown_length_streams_chunked_body
    serve(handler: lambda { |socket, _first, headers, _body|
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

  def test_rejected_upload_raises_without_deadlock_or_reading_the_entire_source
    reads = 0
    source = Object.new
    source.define_singleton_method(:read) do |length|
      reads += 1
      "a" * length
    end
    serve(read_body: false, handler: lambda { |socket, *_|
      respond(socket, status: 413, body: "rejected")
      socket.read # Drain queued bytes so TCP close cannot erase the reply.
    }) do |url|
      error = Timeout.timeout(3) do
        assert_raises(Peddler::Error) { client(url).upload_document(url, source, content_type: "text/plain", content_length: 64 * 1024 * 1024) }
      end

      assert_equal(413, error.status)
      assert_equal("rejected", error.response.body)
    end
    assert_operator(reads, :<, 128)
  end

  def test_upload_length_mismatch_and_source_exception_are_sanitized
    serve(count: 3, handler: lambda { |socket, *_|
      begin
        socket.read
      rescue Errno::ECONNRESET
        nil
      end
    }) do |url|
      instance = client(url)
      [2, 4].each do |length|
        error = assert_raises(Peddler::DocumentError) { instance.upload_document(url, "abc", content_type: "text/plain", content_length: length) }
        assert_match(/length mismatch/, error.message)
      end
      source_exception = RuntimeError.new("private-secret IO URL")
      source = Object.new
      source.define_singleton_method(:read) do |_|
        sleep(0.02)
        raise source_exception
      end
      error = assert_raises(Peddler::DocumentError) { instance.upload_document(url, source, content_type: "text/plain") }
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
        rescue Peddler::DocumentError
          :closed
        end
      end
      started.pop
      Thread.pass until thread.status == "sleep"
      assert_raises(Peddler::DocumentError) { stream.each_jsonl.to_a }
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
      assert_raises(Peddler::DocumentTimeoutError) { stream.each_chunk { sleep(0.05) } }
      assert_predicate(stream, :closed?)
      assert_equal("recovered", instance.download_document(url).each_chunk.to_a.join)
    end
  end

  def test_bounded_whole_json_preserves_numbers_and_rust_limits_map_to_document_errors
    serve(count: 4, handler: lambda { |socket, first, *_|
      body = case first[1]
      when "/json" then '{"n":0,"d":0.12345678901234567890123456789,"n":123456789012345678901234567890}'
      when "/utf8" then "\xFF\tx\n".b
      else "abcd"
      end
      respond(socket, body: body)
    }) do |url|
      instance = client(url)
      value = instance.download_document("#{url}/json").json(max_bytes: 100)

      # The keys come in the document's order, and a repeated key keeps its last value, as in a JSONL row.
      assert_equal(["n", "d"], value.keys)
      assert_equal(123456789012345678901234567890, value.fetch("n"))
      assert_equal(BigDecimal("0.12345678901234567890123456789"), value.fetch("d"))
      assert_raises(Peddler::DocumentError) { instance.download_document("#{url}/bytes", max_bytes: 3).each_chunk.to_a }
      assert_raises(Peddler::DocumentError) { instance.download_document("#{url}/record", max_record_bytes: 3).each_jsonl.to_a }
      assert_raises(Peddler::DocumentError) { instance.download_document("#{url}/utf8").each_tsv.to_a }
    end
  end

  def test_thread_kill_while_native_upload_waits_for_backpressure_releases_socket
    started = Queue.new
    source = Object.new
    source.define_singleton_method(:read) { |length| "a" * length }
    serve(count: 2, handler: lambda { |socket, first, *_|
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

  # A row the stream has buffered is read without releasing the GVL. Released once per row, every row waited for a
  # busy thread's time slice: about 9 rows a second, so about 45 in this window.
  def test_rows_keep_coming_while_another_ruby_thread_runs
    rows = 3_000
    body = Array.new(rows) { |index| "row-#{index}\tvalue\n" }.join
    serve(handler: ->(socket, *) { respond(socket, body: body) }) do |url|
      spinner = Thread.new do
        spins = 0
        loop { spins += 1 }
      end
      read = 0
      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      client(url).download_document("#{url}/document") do |document|
        document.each_tsv do
          read += 1
          break if Process.clock_gettime(Process::CLOCK_MONOTONIC) - start > 5
        end
      end

      assert_equal(rows, read)
    ensure
      spinner&.kill&.join
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
