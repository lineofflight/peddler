# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class Tokens20210301Test < Minitest::Test
      include FeatureHelpers

      def test_create_restricted_data_token
        res = api.create_restricted_data_token({
          "value" => {
            "targetApplication" => "amzn1.sellerapps.app.target-application",
            "restrictedResources" => [{ "method" => "GET", "path" => "/orders/v0/orders/{orderId}/address" }],
          },
        })

        assert_success(res)
      end
    end
  end
end
