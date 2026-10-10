# frozen_string_literal: true

require "webmock"
require "peddler"

module WebMock
  module HttpLibAdapters
    # Puts WebMock between Peddler and the network
    #
    # Peddler's requests are made by its native extension, where WebMock's other adapters don't see them. Require
    # this file after WebMock, and while WebMock is enabled every exchange Peddler makes goes through it: the
    # operations and Peddler::Client#request, the grants of Peddler::LWA, and the downloads and uploads of signed
    # URLs. `stub_request`, `assert_requested`, `WebMock.disable_net_connect!` and VCR's `hook_into :webmock` then
    # work as they do for any HTTP library.
    #
    # WebMock doesn't say whether it is enabled, so the adapter tells when it loads, by whether Net::HTTP is
    # swapped. Require this file before a selective `WebMock.enable!(except: ...)`, which then enables it with the
    # rest. Required after one that leaves Net::HTTP out, the adapter stays off, and Peddler's requests reach the
    # network.
    #
    # Only the exchange is replaced. A stubbed response is retried, paginated, parsed and raised on as one from
    # Amazon is. `to_timeout` raises what a timeout does: Peddler::TimeoutError, or
    # Peddler::DocumentTimeoutError for a signed URL. `to_raise` raises the error itself.
    #
    # A document isn't streamed while WebMock is enabled: an upload is read to its end before it is sent, and a
    # download arrives whole before its first row is read.
    #
    # WebMock works in the main Ractor only: its stubs live there. While it is enabled, a call Peddler makes in
    # another Ractor raises `Ractor::IsolationError` and sends nothing.
    #
    # Example:
    #
    #     require "webmock/minitest"
    #     require "peddler/webmock"
    #
    #     stub_request(:get, %r{/orders/v0/orders}).to_return(status: 200, body: '{"payload":{"Orders":[]}}')
    class PeddlerAdapter < HttpLibAdapter
      adapter_for :peddler

      class << self
        def enable! # :nodoc:
          ::Peddler::Native.exchange_hook = self
        end

        def disable! # :nodoc:
          ::Peddler::Native.exchange_hook = nil
        end

        # What the native layer does with a request it is about to send: answer it with `[status, headers, body]`,
        # time it out with `:timeout`, or send it and report the response to `completed` with the signature
        # returned here
        def call(method, url, headers, body) # :nodoc:
          signature = RequestSignature.new(method.downcase.to_sym, url, headers: named(headers), body: text(body))
          RequestRegistry.instance.requested_signatures.put(signature)
          response = StubRegistry.instance.response_for_request(signature)
          unless response
            return signature if WebMock.net_connect_allowed?(signature.uri)

            raise NetConnectNotAllowedError, signature
          end
          return :timeout if response.should_timeout

          response.raise_error_if_any
          CallbackRegistry.invoke_callbacks({ lib: :peddler }, signature, response)
          [response.status.first.to_i, pairs(response.headers), response.body]
        end

        # Reports the response of a request that went to the network, so that VCR records it
        def completed(signature, status, headers, body) # :nodoc:
          return unless CallbackRegistry.any_callbacks?

          reason = ::Peddler::Native.status_reason(status).to_s
          response = Response.new(status: [status, reason], headers: named(headers), body: text(body))
          CallbackRegistry.invoke_callbacks({ lib: :peddler, real_request: true }, signature, response)
        end

        private

        # Pairs as the Hash WebMock takes, a header that repeats with every value
        def named(headers)
          headers.each_with_object({}) do |(name, value), hash|
            hash[name] = hash.key?(name) ? [*hash[name], value] : value
          end
        end

        # The headers of a stubbed response as pairs of text, as the native layer keeps those of a real one
        def pairs(headers)
          headers.to_h.flat_map do |name, value|
            Array(value).map { |one| [name, one.to_s.dup.force_encoding(Encoding::UTF_8).scrub] }
          end
        end

        # The bytes of a body as text when they are text, so that a matcher and a cassette read them
        def text(body)
          body.force_encoding(Encoding::UTF_8)
          body.valid_encoding? ? body : body.force_encoding(Encoding::BINARY)
        end
      end

      # WebMock doesn't say whether it is enabled, but its Net::HTTP adapter swaps the constant while it is. See the
      # comment of the class for the `enable!` this misreads.
      enable! unless ::Net::HTTP.equal?(NetHttpAdapter::OriginalNetHTTP)
    end
  end
end
