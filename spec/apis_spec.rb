require_relative 'spec_helper'

module Peddler
  describe Products do
    before do
      @products = Products.new(*::MWS_KEYS.values)
    end

    it 'includes a marketplace id by default' do
      assert Products.params.has_key?('MarketplaceId')
    end

    it 'makes a request' do
      res = @products.post('Action' => 'ListMatchingProducts', 'Query' => 'Ruby')
      res.body.wont_be_empty
    end
  end
end
