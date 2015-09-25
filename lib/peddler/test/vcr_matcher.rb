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
        req_1.uri == req_2.uri
      end

      def compare_body
        extract_params(req_1.body) == extract_params(req_2.body)
      end

      def extract_params(body)
        params = ::CGI.parse(body)
        TRANSIENT_PARAMS.each do |k|
          params.delete(k)
        end

        params
      end
    end
  end
end
