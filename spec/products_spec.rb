require_relative 'spec_helper'

module Peddler
  describe Products do
    before do
      @service = Products.new(*::MWS_KEYS.values)
    end

    it 'configures the endpoint path' do
      @service.endpoint.must_match(/Products/)
    end

    it 'lists matching products' do
      res = @service.list_matching_products(query: 'architecture')
      res.status.must_equal 200
    end

    it 'gets matching products' do
      res = @service.get_matching_product(asins: ['0826477151', '1780935374'])
      res.status.must_equal 200
    end

    it 'gets matching products for ids' do
      res = @service.get_matching_product_for_id(id_type: 'ASIN', ids: '0826477151')
      res.status.must_equal 200
    end

    it 'gets competitive pricing for SKUs' do
      res = @service.get_competitive_pricing_for_sku(skus: '123')
      res.status.must_equal 200
    end

    it 'gets competitive pricing for ASINs' do
      res = @service.get_competitive_pricing_for_asin(asins: '0826477151')
      res.status.must_equal 200
    end

    it 'gets lowest offer listings for SKUs' do
      res = @service.get_lowest_offer_listings_for_sku(skus: '123')
      res.status.must_equal 200
    end

    it 'gets lowest offer listings for ASINs' do
      res = @service.get_lowest_offer_listings_for_asin(asins: ['0826477151', '1780935374'])
      res.status.must_equal 200
    end

    it 'gets my price for SKUs' do
      res = @service.get_my_price_for_sku(skus: '123')
      res.status.must_equal 200
    end

    it 'gets my price for ASINs' do
      res = @service.get_my_price_for_asin(asins: '0826477151')
      res.status.must_equal 200
    end

    it 'gets product categories for ASINs' do
      res = @service.get_product_categories_for_asin(asin: '0826477151')
      res.status.must_equal 200
    end
  end
end
