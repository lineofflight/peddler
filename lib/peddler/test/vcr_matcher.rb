module Peddler
  module Test
    class VCRMatcher
      TRANSIENT_PARAMS = %w( AWSAccessKeyId SellerId Signature Timestamp
                             StartDate CreatedAfter QueryStartDateTime ).freeze

      attr_reader :req_1, :req_2

      def self.call(req_1, req_2)
        new(req_1, req_2).compare
      end

      def initialize(req_1, req_2)
        @req_1 = req_1
        @req_2 = req_2
      end

      def compare
        compare_uri && compare_body
      end

      private

      def compare_uri
        uri_1 = URI.parse(req_1.uri)
        uri_2 = URI.parse(req_2.uri)

        uri_1.host == uri_2.host &&
          uri_1.path == uri_2.path &&
          extract_params(uri_1.query) == extract_params(uri_2.query)
      end

      def compare_body
        extract_params(req_1.body) == extract_params(req_2.body)
      end

      def extract_params(string)
        return {} unless string

        params = ::CGI.parse(string)
        TRANSIENT_PARAMS.each do |k|
          params.delete(k)
        end

        params
      end
    end
  end
end
