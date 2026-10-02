# frozen_string_literal: true

require_relative "test_helper"

# Each test checks one real request lifecycle.
# rubocop:disable Minitest/MultipleAssertions
class RuntimeTest < NativeTest
  def test_refresh_shared_across_ruby_threads_and_generated_calls
    calls = Queue.new
    serve(handler: lambda { |socket, first, _headers, body|
      assert_equal("POST", first[0])
      assert_equal("refresh_token", URI.decode_www_form(body).to_h.fetch("grant_type"))
      calls << true
      respond(socket, body: JSON.generate(access_token: "fresh", token_type: "bearer", expires_in: 3600))
    }) do |lwa|
      serve(count: 6, handler: lambda { |socket, _first, headers, _body|
        assert_equal("fresh", headers.fetch("x-amz-access-token"))
        respond(socket)
      }) do |url|
        instance = Peddler::Client.new(base_url: url, client_id: "dummy", client_secret: "dummy-secret", refresh_token: "dummy-refresh", lwa_endpoint: lwa)
        threads = Array.new(6) do |index|
          Thread.new do
            if index.even?
              instance.request("GET", "/")
            else
              instance.catalog_items_2022_04_01.get_catalog_item(asin: "ASIN", marketplace_ids: ["UK"])
            end
          end
        end

        threads.each { |thread| assert_equal(200, thread.value.status) }
      end
    end

    assert_equal(1, calls.size)
  end

  def test_restricted_views_reuse_token_and_pool
    count = 0
    serve(count: 3, handler: lambda { |socket, first, headers, body|
      count += 1
      if first[1] == "/tokens/2021-03-01/restrictedDataToken"
        assert_equal("local-secret", headers.fetch("x-amz-access-token"))
        assert_equal("GET", JSON.parse(body).fetch("restrictedResources")[0].fetch("method"))
        respond(socket, body: JSON.generate(restrictedDataToken: "rdt", expiresIn: 3600))
      else
        assert_equal("rdt", headers.fetch("x-amz-access-token"))
        respond(socket)
      end
    }) do |url|
      instance = client(url)
      2.times do
        view = instance.restricted(resources: [{ method: "GET", path: "/private" }])

        assert_equal(200, view.request("GET", "/private").status)
      end
    end

    assert_equal(3, count)
  end

  def test_status_errors_preserve_binary_body_and_duplicate_headers
    serve(handler: lambda { |socket, *|
      respond(socket, status: 429, headers: [["x-repeat", "a"], ["x-repeat", "b"], ["x-amzn-requestid", "request-id"]], body: "\xFF\x00".b)
    }) do |url|
      error = assert_raises(Peddler::Error) { client(url).request("GET", "/") }
      response = error.response

      assert_same(response, assert_raises(Peddler::Error) { response.raise_for_status! }.response)
      assert_equal(429, error.status)
      assert_equal("request-id", error.request_id)
      assert_nil(error.code)
      assert_equal("request failed with status 429", error.message)
      assert_equal("\xFF\x00".b, error.response.body)
      assert_equal([["x-repeat", "a"], ["x-repeat", "b"]], response.headers.select { |name, _| name == "x-repeat" })
    end
    serve(handler: ->(socket, *) { respond(socket) }) do |url|
      response = client(url).request("GET", "/")

      assert_same(response, response.raise_for_status!)
    end
  end

  def test_configuration_rejection_is_sanitized_and_performs_no_http
    [{}, { access_token: "dummy", client_id: "dummy" }, { client_id: "dummy", client_secret: "dummy" },
      { client_id: "dummy", client_secret: "dummy", refresh_token: "dummy", scope: "dummy" },
      { access_token: "dummy", retries: -1 }, { access_token: "dummy", rate_limits: { raw: { rate: 0, burst: 1 } } }].each do |options|
      error = assert_raises(ArgumentError) { Peddler::Client.new(base_url: "http://127.0.0.1:1", **options) }
      refute_match(/dummy/, error.message)
    end
    error = assert_raises(ArgumentError) { Peddler::Native.const_get(:Engine).from_config('{"secret":"dummy-secret"}') }
    refute_match(/dummy-secret|secret/, error.message)
  end

  def test_raw_operation_routes_rate_limits_and_preserves_final_retry_body
    serve(count: 2, handler: ->(socket, *) { respond(socket, status: 429, headers: [["Retry-After", "1"]], body: "retained") }) do |url|
      instance = client(url, timeout: 0.03, retries: 1, rate_limits: { slow: { rate: 0.1, burst: 1 } })

      # After the retry policy is exhausted, the last response raises like any other.
      assert_equal("retained", assert_raises(Peddler::Error) { instance.request("GET", "/", operation: "slow") }.response.body)
      assert_raises(Peddler::TimeoutError) { instance.request("GET", "/", operation: "slow") }
      assert_equal("retained", assert_raises(Peddler::Error) { instance.request("GET", "/", operation: "other") }.response.body)
    end
  end

  def test_restricted_view_survives_parent_gc_and_rejects_inherited_state
    serve(count: 2, handler: lambda { |socket, first, *_|
      if first[1].start_with?("/tokens/")
        respond(socket, body: JSON.generate(restrictedDataToken: "rdt", expiresIn: 3600))
      else
        respond(socket)
      end
    }) do |url|
      instance = client(url)
      view = instance.restricted(resources: [{ method: "GET", path: "/" }])
      instance = nil
      GC.start

      assert_equal(200, view.request("GET", "/").status)
      reader, writer = IO.pipe
      pid = fork do
        reader.close
        begin
          view.restricted(resources: [{ method: "GET", path: "/" }])
          writer.write("failed")
        rescue Peddler::ForkError
          writer.write("guarded")
        end
        writer.close
        exit!(0)
      end
      writer.close

      assert_equal("guarded", reader.read)
      Process.wait(pid)
      reader.close
    end
  end

  def test_interrupted_auth_refresh_closes_socket_and_client_recovers
    started = Queue.new
    calls = 0
    serve(count: 2, handler: lambda { |socket, *|
      calls += 1
      if calls == 1
        started << true

        assert_nil(socket.read(1))
      else
        respond(socket, body: JSON.generate(access_token: "recovered", token_type: "bearer", expires_in: 3600))
      end
    }) do |lwa|
      serve(handler: ->(socket, *) { respond(socket) }) do |url|
        instance = Peddler::Client.new(base_url: url, client_id: "dummy", client_secret: "dummy", refresh_token: "dummy", lwa_endpoint: lwa)
        thread = Thread.new { instance.request("GET", "/") }
        started.pop
        thread.kill
        thread.join

        assert_equal(200, instance.request("GET", "/").status)
      end
    end
  end

  def test_error_code_and_message_are_rust_metadata_and_nothing_else_from_the_body_is_shown
    body = '{"errors":[{"code":"InvalidInput","message":"Amazon says no","details":"dummy-private"}]}'
    serve(handler: ->(socket, *) { respond(socket, status: 400, body: body) }) do |url|
      error = assert_raises(Peddler::Error) { client(url).request("GET", "/") }

      assert_equal("InvalidInput", error.code)
      assert_equal("Amazon says no", error.message)
      refute_match(/dummy-private|local-secret/, error.message)
      refute_match(/dummy-private|local-secret/, error.inspect)
      refute_respond_to(error, :kind)
    end
  end

  def test_manually_constructed_response_uses_rust_status_classification
    response = Peddler::Response.new(404, [["x-amzn-requestid", "manual-id"]], '{"errors":[{"code":"NotFound"}]}')
    error = assert_raises(Peddler::Error) { response.raise_for_status! }
    assert_same(response, error.response)
    assert_equal(404, error.status)
    assert_equal("NotFound", error.code)
    assert_equal("manual-id", error.request_id)
  end

  def test_authentication_error_has_status_and_redacts_server_body
    serve(handler: ->(socket, *) { respond(socket, status: 401, body: "dummy-secret") }) do |lwa|
      instance = Peddler::Client.new(base_url: "http://127.0.0.1:1", client_id: "dummy", client_secret: "dummy-secret", refresh_token: "dummy", lwa_endpoint: lwa)
      error = assert_raises(Peddler::AuthenticationError) { instance.request("GET", "/") }
      assert_equal(401, error.status)
      refute_match(/dummy/, error.message)
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
