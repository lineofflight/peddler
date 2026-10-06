# frozen_string_literal: true

require_relative "test_helper"

# Each test checks one real request lifecycle.
# rubocop:disable Minitest/MultipleAssertions
class RuntimeTest < NativeTest
  def test_supplied_token_is_sent_across_ruby_threads_and_generated_calls
    serve(count: 6, handler: lambda { |socket, _first, headers, _body|
      assert_equal("local-secret", headers.fetch("x-amz-access-token"))
      assert_match(AMZ_DATE, headers["x-amz-date"])
      assert_equal(gem_user_agent, headers["user-agent"])
      respond(socket)
    }) do |url|
      instance = client(url)
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

  def test_restricted_data_token_is_an_ordinary_call_whose_result_a_view_sends
    serve(count: 4, handler: lambda { |socket, first, headers, body|
      if first[1] == "/tokens/2021-03-01/restrictedDataToken"
        assert_equal("POST", first[0])
        assert_equal("local-secret", headers.fetch("x-amz-access-token"))
        assert_equal("GET", JSON.parse(body).fetch("restrictedResources")[0].fetch("method"))
        respond(socket, body: JSON.generate(restrictedDataToken: "rdt", expiresIn: 3600))
      else
        assert_equal(first[1] == "/private" ? "rdt" : "local-secret", headers.fetch("x-amz-access-token"))
        respond(socket)
      end
    }) do |url|
      instance = client(url)
      token = instance.tokens.create_restricted_data_token(body: { restrictedResources: [{ method: "GET", path: "/private" }] })
        .parse.restricted_data_token
      view = instance.with_access_token(token)

      # Nothing is cached: the view sends what it was given, and the client keeps its own token.
      2.times { assert_equal(200, view.request("GET", "/private").status) }
      assert_equal(200, instance.request("GET", "/").status)
    end
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
    [{}, { access_token: nil }, { access_token: "" }, { access_token: "dummy\n" },
      { access_token: "dummy", retries: -1 }, { access_token: "dummy", retries: 11 },
      { access_token: "dummy", timeout: 0 }].each do |options|
      error = assert_raises(ArgumentError, options.inspect) { Peddler::Client.new(base_url: "http://127.0.0.1:1", **options) }
      refute_match(/dummy/, error.message)
    end
    error = assert_raises(ArgumentError) { Peddler::Native.const_get(:Engine).from_config('{"secret":"dummy-secret"}') }
    refute_match(/dummy-secret|secret/, error.message)
  end

  def test_retries_a_throttled_get_but_never_a_write
    replies = [[429, "throttled"], [200, "{}"], [429, "write-throttled"]]
    seen = Queue.new
    serve(count: 3, handler: lambda { |socket, first, headers, _body|
      seen << [first[0], headers["x-amz-access-token"]]
      status, body = replies.shift
      respond(socket, status: status, headers: [["Retry-After", "0"]], body: body)
    }) do |url|
      instance = client(url, retries: 2)

      assert_equal(200, instance.request("GET", "/").status)
      assert_equal("write-throttled", assert_raises(Peddler::Error) { instance.request("POST", "/", body: {}) }.response.body)
    end

    assert_equal([["GET", "local-secret"], ["GET", "local-secret"], ["POST", "local-secret"]], Array.new(3) { seen.pop })
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

  def test_sandbox_view_is_built_once_and_sends_the_same_token
    serve(count: 3, handler: lambda { |socket, _first, headers, _body|
      respond(socket, body: JSON.generate(token: headers["x-amz-access-token"]))
    }) do |url|
      # A region whose sandbox host is the loopback server; production is never contacted.
      endpoint = Struct.new(:production, :sandbox).new(URI("http://127.0.0.1:1"), URI(url))
      instance = Peddler::Endpoint.stub(:find, endpoint) do
        Peddler::Client.new(region: "eu-west-1", access_token: "sandbox-token")
      end

      assert_same(instance.sandbox, instance.sandbox)
      2.times { assert_equal("sandbox-token", instance.sandbox.request("GET", "/").to_h["token"]) }
      assert_equal("rotated", instance.with_access_token("rotated").sandbox.request("GET", "/").to_h["token"])
    end
  end

  def test_message_falls_back_when_the_body_has_none
    bodies = { "" => nil, "invalid xml content" => nil, "503" => nil, '{"errors":[]}' => nil,
               '{"errors":[{"code":"InternalFailure"}]}' => "InternalFailure" }
    bodies.each do |body, code|
      serve(handler: ->(socket, *) { respond(socket, status: 503, body: body) }) do |url|
        error = assert_raises(Peddler::Error) { client(url).request("GET", "/") }

        assert_equal("request failed with status 503", error.message, body)
        assert_equal([503, code, nil], [error.status, error.code, error.request_id], body)
      end
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
