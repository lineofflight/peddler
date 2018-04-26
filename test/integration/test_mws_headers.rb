# frozen_string_literal: true

require 'integration_helper'
require 'mws/products'

class TestMWSHeaders < IntegrationTest
  use 'Products'

  def test_parses_headers
    clients.each do |client|
      res = client.get_lowest_priced_offers_for_asin('1780935374', 'New')
      refute_nil res.mws_quota
    end
  end
end
