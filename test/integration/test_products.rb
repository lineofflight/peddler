require 'integration_helper'
require 'mws/products'

class TestProducts < IntegrationTest
  def test_lists_matching_products
    clients.each do |client|
      res = client.list_matching_products('architecture')
      refute_empty res.parse
    end
  end

  def test_gets_matching_product
    clients.each do |client|
      res = client.get_matching_product('1780935374')
      refute_empty res.parse
    end
  end

  def test_gets_matching_product_for_id
    clients.each do |client|
      res = client.get_matching_product_for_id('ISBN', '9781780935379')
      refute_empty res.parse
    end
  end

  def test_gets_competitive_pricing_for_asin
    clients.each do |client|
      res = client.get_competitive_pricing_for_asin('1780935374')
      refute_empty res.parse
    end
  end

  def test_gets_lowest_offer_listings_for_asin
    clients.each do |client|
      res = client.get_lowest_offer_listings_for_asin('1780935374')
      refute_empty res.parse
    end
  end

  def test_gets_lowest_priced_offers_for_asin
    clients.each do |client|
      res = client.get_lowest_priced_offers_for_asin('1780935374', 'New')
      refute_empty res.parse
    end
  end

  def test_gets_product_categories_for_asin
    clients.each do |client|
      res = client.get_product_categories_for_asin('1780935374')
      refute_empty res.parse
    end
  end

  def test_gets_my_fees_estimate
    clients.each do |client|
      res = client.get_my_fees_estimate(
        marketplace_id: client.primary_marketplace_id,
        id_type: 'ASIN',
        id_value: '1780935374',
        price_to_estimate_fees: {
          listing_price: {
            currency_code: currency_code_for(client.primary_marketplace_id),
            amount: 100
          }
        },
        identifier: '123',
        is_amazon_fulfilled: false
      )
      assert res
        .parse
        .dig('FeesEstimateResultList', 'FeesEstimateResult', 'FeesEstimate')
    end
  end

  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end

  private

  CURRENCY_CODES = {
    'A2EUQ1WTGCTBG2' => 'CAD',
    'AAHKV2X7AFYLW'  => 'CNY',
    'A1F83G8C2ARO7P' => 'GBP',
    'A21TJRUUN4KGV'  => 'INR',
    'A1VC38T7YXB528' => 'JPY',
    'A1AM78C64UM0Y8' => 'MXN',
    'ATVPDKIKX0DER'  => 'USD'
  }.freeze

  def currency_code_for(marketplace_id)
    CURRENCY_CODES.fetch(marketplace_id, 'EUR')
  end
end
