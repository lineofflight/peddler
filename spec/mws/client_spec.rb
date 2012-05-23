require 'spec_helper'

module MWS
  describe Client do
    before do
      @client = Client.new 'US'
    end

    describe '#build_list' do
      subject { @client.build_list 'Value', (1..10).to_a }

      it 'uses a dot notation' do
        1.upto(10).each do |count|
          should include "ValueList.Value.#{count}"
        end
      end
    end

    describe '#configure' do
      context 'given a block' do
        before do
          @client.configure do |config|
            config.key = 'foo'
          end
        end

        it 'configures the endpoint' do
          @client.endpoint.key.should eq 'foo'
        end
      end

      context 'given a hash' do
        before do
          @client.configure :key => 'foo'
        end

        it 'configures the endpoint' do
          @client.endpoint.key.should eq 'foo'
        end
      end
    end

    describe '#connection' do
      it 'returns a Faraday connection' do
        @client.connection.should be_a Faraday::Connection
      end

      it 'identifies the library' do
        @client.connection.headers.should have_key 'User-Agent'
      end
    end
  end
end
