# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class DataKiosk20231115HelperTest < Minitest::Test
      def test_download_query_document_method_exists
        api = Peddler.data_kiosk.new("us-east-1", "test-access-token")

        assert_respond_to(api, :download_query_document)
      end
    end
  end
end
