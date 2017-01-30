require 'integration_helper'
require 'mws/products'

class TestMWSHeaders < IntegrationTest
  def setup
    @api = 'Products'
    super
  end

  def test_parses_headers
    clients.each do |client|
      res = client.get_lowest_priced_offers_for_asin('1780935374', 'New')
      refute_nil res.quota
    end
  end
end
