require 'spec_helper'

module MWS
  module API
    describe Products do
      before do
        @client = MWS::Client.new 'US'
        @client.configure do |c|
          c.key       = 'key'
          c.secret    = 'secret'
          c.seller_id = 'seller_id'
        end
      end

      describe '#products_url' do
        subject { @client.products_url 'foo', :param => 'val' }

        it 'returns a URL' do
          should include @client.endpoint.host
        end

        it 'includes the marketplace id' do
          should include 'MarketplaceId='
        end

        it 'includes the seller id' do
          should include 'SellerId='
        end

        it 'includes an action' do
          should include 'Action=foo'
        end

        it 'includes given parameters' do
          should include 'Param=val'
        end
      end
    end
  end
end
