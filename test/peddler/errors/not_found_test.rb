# frozen_string_literal: true

require "helper"

module Peddler
  module Errors
    class NotFoundTest < Minitest::Test
      include FeatureHelpers

      def test_not_found
        error = assert_raises(Peddler::Errors::NotFound) do
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
