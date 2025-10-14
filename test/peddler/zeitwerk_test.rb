# frozen_string_literal: true

require "helper"

class ZeitwerkTest < Minitest::Test
  def test_convenience_methods_return_api_classes
    assert_equal(Peddler::APIs::OrdersV0, Peddler.orders)
    assert_equal(Peddler::APIs::CatalogItems20220401, Peddler.catalog_items)
    assert_equal(Peddler::APIs::Reports20210630, Peddler.reports)
  end

  def test_versioned_methods_still_work
    assert_equal(Peddler::APIs::OrdersV0, Peddler.orders_v0)
    assert_equal(Peddler::APIs::CatalogItems20220401, Peddler.catalog_items_2022_04_01)
    assert_equal(Peddler::APIs::Reports20210630, Peddler.reports_2021_06_30)
  end
end
