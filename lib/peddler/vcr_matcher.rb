# frozen_string_literal: true

module Peddler
  # A custom matcher that can be used to record MWS interactions when
  # writing integration tests
  class VCRMatcher
    # @!visibility private
    TRANSIENT_PARAMS = %w[
      Signature Timestamp StartDate CreatedAfter QueryStartDateTime
    ].freeze

    # @!visibility private
    SELLER_PARAMS = %w[
      AWSAccessKeyId SellerId
    ].freeze

    class << self
      # @!visibility private
      def call(*requests)
        new(*requests).compare
      end

      # @!visibility private
      def ignored_params
        @ignored_params ||= TRANSIENT_PARAMS.dup
      end

      # Ignore seller specific attributes when recording
      # @return [void]
      def ignore_seller!
        ignored_params.concat(SELLER_PARAMS)
        ignored_params.uniq!
      end
    end

    # @!visibility private
    attr_reader :requests

    # @!visibility private
    def initialize(*requests)
      @requests = requests
    end

    # @!visibility private
    def compare
      compare_uris && compare_bodies
    end

    private

    def compare_uris
      return false if hosts.reduce(:!=) || paths.reduce(:!=)
      return true if queries.all?(&:empty?)

      queries.reduce(:==)
    end

    def compare_bodies
      bodies.reduce(:==)
    end

    def extract_params(string)
      return {} unless string

      params = ::CGI.parse(string)
      self.class.ignored_params.each do |k|
        params.delete(k)
      end

      params
    end

    def uris
      requests.map { |r| URI.parse(r.uri) }
    end

    def hosts
      uris.map(&:host)
    end

    def paths
      uris.map(&:path)
    end

    def queries
      uris.map { |uri| extract_params(uri.query) }
    end

    def bodies
      if queries.all?(&:empty?)
        requests.map { |request| extract_params(request.body) }
      else
        requests.map(&:body)
      end
    end
  end
end
