# frozen_string_literal: true

require "helper"
require "peddler"

class PeddlerTest < Minitest::Test
  def setup
    # Reset configuration to default
    Peddler::Config.instance_variable_set(:@raise_on_server_errors, nil)
  end

  def teardown
    # Reset configuration after each test
    Peddler::Config.instance_variable_set(:@raise_on_server_errors, nil)
  end

  def test_entrypoint
    refute_empty(Peddler::APIs.constants)
  end

  def test_convenience_methods
    assert_equal(Peddler::APIs::FBAInventoryV1, Peddler.fba_inventory_v1)
    assert_equal(Peddler::APIs::Reports20210630, Peddler.reports_2021_06_30)
    assert_equal(Peddler::APIs::ProductPricing20220501, Peddler.product_pricing)
  end

  def test_default_raise_on_server_errors_is_false
    refute(Peddler.raise_on_server_errors)
  end

  def test_can_set_raise_on_server_errors
    Peddler.raise_on_server_errors = true

    assert(Peddler.raise_on_server_errors)
  end

  def test_configure_block
    Peddler.configure do |config|
      config.raise_on_server_errors = true
    end

    assert(Peddler.raise_on_server_errors)
  end
end
