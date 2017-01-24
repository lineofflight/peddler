require 'integration_helper'
require 'mws/products'

class TestMultibyteQueries < IntegrationTest
  def setup
    @api = 'Products'
    super
  end

  def test_posts_multibyte_queries_properly
    ret = clients.map do |client|
      res = client.list_matching_products('félix guattari machinic eros')
      res.parse
    end
    assert ret.map(&:to_s).join.include?('Félix')
  end
end
