# frozen_string_literal: true

require 'integration_helper'
require 'mws/products'

class TestMultibyteQueries < IntegrationTest
  use 'Products'

  def test_posting_multibyte_queries_properly
    ret = clients.map do |client|
      res = client.list_matching_products(client.marketplace.id, 'félix guattari machinic eros')
      res.body.force_encoding 'UTF-8' if defined? Ox # Ox workaround
      res.parse
    end
    assert_includes ret.map(&:to_s).join, 'Félix'
  end
end
