# frozen_string_literal: true

require "helper"

require "peddler/apis/reports_2021_06_30"

module Peddler
  class Error
    class NotFoundTest < Minitest::Test
      include FeatureHelpers

      def test_not_found
        error = assert_raises(NotFound) do
          api.get_report("1234567")
        end
        assert_equal(404, error.response.status)
      end

      private

      def api_class
        APIs::Reports20210630
      end
    end
  end
end
