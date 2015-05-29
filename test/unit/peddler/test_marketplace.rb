require 'helper'
require 'peddler/marketplace'

class TestPeddlerMarketplace < MiniTest::Test
  def setup
    @marketplace = Peddler::Marketplace.new('ATVPDKIKX0DER')
  end

  def test_has_a_host
    assert @marketplace.host
  end

  def test_has_an_encoding
    assert @marketplace.encoding
  end

  def test_guard_against_missing_marketplace_id
    assert_raises(Peddler::Marketplace::BadId, 'missing MarketplaceId') do
      Peddler::Marketplace.new(nil)
    end
  end

  def test_guard_against_bad_marketplace_id
    assert_raises(Peddler::Marketplace::BadId, '"123" is not a valid MarketplaceId') do
      marketplace = Peddler::Marketplace.new('123')
      marketplace.host
    end
  end
end
