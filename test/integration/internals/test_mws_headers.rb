# frozen_string_literal: true

require 'integration_helper'
require 'mws/products'

class TestMWSHeaders < IntegrationTest
  use 'Products'

  def test_parsing_headers
    clients.each do |client|
      res = client.get_lowest_priced_offers_for_asin(client.marketplace.id,
                                                     '1780935374', 'New')
      refute_nil res.mws_quota_max
      refute_nil res.mws_quota_remaining
      refute_nil res.mws_quota_resets_on
      refute_nil res.mws_request_id
      refute_nil res.mws_timestamp
      refute_nil res.mws_response_context
    end
  end
end
