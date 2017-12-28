# frozen_string_literal: true

require 'helper'
require 'peddler/marketplace'

class TestPeddlerMarketplace < MiniTest::Test
  def setup
    @marketplace = Peddler::Marketplace.find('ATVPDKIKX0DER')
  end

  def test_country_code
    assert @marketplace.country_code
  end

  def test_host
    assert @marketplace.host
  end

  def test_encoding
    assert @marketplace.encoding
  end

  def test_guard_against_missing_marketplace_id
    assert_raises(ArgumentError, 'missing ID') do
      Peddler::Marketplace.find(nil)
    end
  end

  def test_guard_against_invalid_marketplace_id
    assert_raises(ArgumentError, '"123" is not a valid ID') do
      Peddler::Marketplace.find('123')
    end
  end
end
