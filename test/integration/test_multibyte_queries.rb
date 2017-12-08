# frozen_string_literal: true

require 'integration_helper'
require 'mws/products'

class TestMultibyteQueries < IntegrationTest
  use 'Products'

  def test_posts_multibyte_queries_properly
    ret = clients.map do |client|
      res = client.list_matching_products('félix guattari machinic eros')
      res.body.force_encoding 'UTF-8' if defined? Ox # Ox workaround
      res.parse
    end
    assert ret.map(&:to_s).join.include?('Félix')
  end
end
