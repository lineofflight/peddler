# frozen_string_literal: true

module Peddler
  module Native
    class << self
      # A token is a non-empty String of valid UTF-8, whether it is given or a source returns it. The error never
      # shows the value.
      def access_token(value)
        unless value.is_a?(String) && !value.empty? && value.valid_encoding? &&
            (value.encoding == Encoding::UTF_8 || value.ascii_only?)
          raise ArgumentError, "invalid access token"
        end

        value
      end

      # The value, if it is a token source: anything that responds to call
      def token_source(value)
        value if value.respond_to?(:call)
      end

      def sourced_engine(engine, source)
        SourcedEngine.new(engine, source)
      end
    end

    # Stands in for an engine when the access token comes from a source. It asks the source before each request it
    # starts and sends that request through a view with the token. A view shares the process's connection pool, and
    # nothing the source returns is kept past the request.
    class SourcedEngine
      def initialize(engine, source)
        @engine = engine
        @source = source
        @pid = Process.pid
      end

      # A source is the caller's object and may hold a refresh token, so nothing of it is shown.
      def inspect = "#<Peddler::Native::SourcedEngine>"

      def with_base_url(base_url)
        self.class.new(@engine.with_base_url(base_url), @source)
      end

      # A view with a fixed token, or with none, to pair with another source
      def with_access_token(access_token)
        @engine.with_access_token(access_token)
      end

      def request(method, path, query, body)
        view.request(method, path, query, body)
      end

      def operation(operation, arguments)
        view.operation(operation, arguments)
      end

      # The helpers below run their loop in Rust, so each asks the source once, when it starts.

      def download_report_document(id, config)
        view.download_report_document(id, config)
      end

      def download_feed_document(id, config)
        view.download_feed_document(id, config)
      end

      def download_query_document(id, config)
        view.download_query_document(id, config)
      end

      def wait_for_report(id, interval, timeout)
        view.wait_for_report(id, interval, timeout)
      end

      def wait_for_feed(id, interval, timeout)
        view.wait_for_feed(id, interval, timeout)
      end

      def wait_for_query(id, interval, timeout)
        view.wait_for_query(id, interval, timeout)
      end

      def start_feed_document_upload(content_type, config, content_length)
        view.start_feed_document_upload(content_type, config, content_length)
      end

      # Signed URLs carry no token, so the source isn't asked.

      def download_document(url, config)
        @engine.download_document(url, config)
      end

      def start_document_upload(url, config, content_type, headers, content_length)
        @engine.start_document_upload(url, config, content_type, headers, content_length)
      end

      private

      # The source is the caller's code and may use a socket the child inherited, so the process is checked first.
      def view
        raise ForkError, "create a new client after fork" unless Process.pid == @pid

        @engine.with_access_token(Native.access_token(@source.call))
      end
    end

    private_constant :SourcedEngine
  end
end
