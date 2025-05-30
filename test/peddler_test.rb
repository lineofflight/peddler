# frozen_string_literal: true

require "helper"
require "peddler"

class PeddlerTest < Minitest::Test
  def test_entrypoint
    refute_empty(Peddler::APIs.constants)
  end

  def test_convenience_methods
    assert_instance_of(Peddler::APIs::FBAInventoryV1, Peddler.fba_inventory_v1("us-east-1", "access_token"))
    assert_instance_of(Peddler::APIs::Reports20210630, Peddler.reports_2021_06_30("us-east-1", "access_token"))
    assert_instance_of(Peddler::APIs::ProductPricing20220501, Peddler.product_pricing("us-east-1", "access_token"))
  end
end
