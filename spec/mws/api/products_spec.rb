require 'spec_helper'

module MWS
  module API
    describe Products do
      before do
        @client = Client.new 'US'
        @client.configure do |config|
          config.key       = 'foo'
          config.seller_id = 'bar'
          config.secret    = 'baz'
        end
      end

      describe '#products_url_builder' do
        subject { @client.products_url_builder }

        it 'returns a URL builder' do
          should { be_an AWS::URL }
        end

        it 'includes the marketplace id' do
          subject.params.should have_key 'MarketplaceId'
        end
      end

      describe '#get_lowest_offer_listings_for_asin'
    end
  end
end
