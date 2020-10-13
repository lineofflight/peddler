# frozen_string_literal: true

require 'integration_helper'
require 'mws/products'

class TestProducts < IntegrationTest
  def test_listing_matching_products
    clients.each do |client|
      res = client.list_matching_products(client.marketplace.id, 'architecture')
      refute_empty res.parse
    end
  end

  def test_getting_matching_product
    clients.each do |client|
      res = client.get_matching_product(client.marketplace.id, '1780935374')
      refute_empty res.parse
    end
  end

  def test_getting_matching_product_for_id
    clients.each do |client|
      res = client.get_matching_product_for_id(client.marketplace.id, 'ISBN', '9781780935379')
      refute_empty res.parse
    end
  end

  def test_getting_competitive_pricing_for_asin
    clients.each do |client|
      res = client.get_competitive_pricing_for_asin(client.marketplace.id, '1780935374')
      refute_empty res.parse
    end
  end

  def test_getting_lowest_offer_listings_for_asin
    clients.each do |client|
      res = client.get_lowest_offer_listings_for_asin(client.marketplace.id, '1780935374')
      refute_empty res.parse
    end
  end

  def test_getting_lowest_priced_offers_for_asin
    clients.each do |client|
      res = client.get_lowest_priced_offers_for_asin(client.marketplace.id, '1780935374', 'New')
      refute_empty res.parse
    end
  end

  def test_getting_product_categories_for_asin
    clients.each do |client|
      res = client.get_product_categories_for_asin(client.marketplace.id, '1780935374')
      refute_empty res.parse
    end
  end

  def test_getting_my_fees_estimate
    clients.each do |client|
      res = client.get_my_fees_estimate(
        marketplace_id: client.marketplace.id,
        id_type: 'ASIN',
        id_value: '0439136369',
        price_to_estimate_fees: {
          listing_price: {
            currency_code: currency_code_for(client.marketplace.id),
            amount: 100
          }
        },
        identifier: '123',
        is_amazon_fulfilled: false
      )
      assert res.dig('FeesEstimateResultList', 'FeesEstimateResult')
    end
  end

  def test_getting_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end

  private

  CURRENCY_CODES = {
    'A2EUQ1WTGCTBG2' => 'CAD',
    'A1F83G8C2ARO7P' => 'GBP',
    'A21TJRUUN4KGV' => 'INR',
    'A1VC38T7YXB528' => 'JPY',
    'A1AM78C64UM0Y8' => 'MXN',
    'ATVPDKIKX0DER' => 'USD',
    'A39IBJ37TRP1C6' => 'AUD',
    'A19VAU5U5O7RUS' => 'SGD'
  }.freeze

  def currency_code_for(marketplace_id)
    CURRENCY_CODES.fetch(marketplace_id, 'EUR')
  end
end
