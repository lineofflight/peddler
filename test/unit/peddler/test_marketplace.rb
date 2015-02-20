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

  def test_guards_against_bad_marketplace_ids
    assert_raises(Peddler::Marketplace::BadId) do
      marketplace = Peddler::Marketplace.new('123')
      marketplace.host
    end
  end
end
