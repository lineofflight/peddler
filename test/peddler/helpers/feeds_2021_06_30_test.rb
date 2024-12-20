# frozen_string_literal: true

require "helper"
require "peddler/helpers/feeds_2021_06_30"

module Peddler
  module Helpers
    class Feeds20210630Test < Minitest::Test
      include Feeds20210630

      def test_upload_feed_document_success
        stub_request(:put, /.*/)
          .to_return(status: 200, body: "", headers: {})

        res = upload_feed_document("https://example.com", "content", "text/plain")

        assert_predicate(res.status, :ok?)
      end

      def test_upload_feed_document_client_error
        stub_request(:put, /.*/)
          .to_return(status: 400,
            body: {
              "errors" => [{
                "code" => "Error",
              }],
            }.to_json)

        assert_raises(Peddler::Error) do
          upload_feed_document("https://example.com", "content", "text/plain")
        end
      end
    end
  end
end
