require 'spec_helper'

module Peddler
  describe Transport do 
    let(:transport) do
      transport = Peddler::Transport.new
      transport.username = 'user'
      transport.password = 'secret'
      transport.region = :us
      transport
    end

    it 'switches regions' do
      transport.legacize_request
      transport.region = :uk
      transport.url.host.should == 'secure.amazon.co.uk'
    end

    it 'raises error when region is invalid' do
      lambda { transport.region = 'foo' }.should raise_error(PeddlerError)
    end

    it 'adds path to legacy URL' do
      transport.legacize_request
      transport.path << 'foo'
      transport.url.to_s.should == 'https://secure.amazon.com/exec/panama/seller-admin/foo'
    end

    it 'adds path to modern URL' do
      transport.modernize_request
      transport.path << 'foo'
      transport.url.to_s.should == 'https://secure.amazon.com/query/foo?Service=MerchantQueryService'
    end

    it 'adds query parameters to the modern URL' do
      transport.modernize_request
      transport.query_params['key1'] = 'val1'
      transport.query_params['key2'] = 'val2'
      uri = URI.parse(transport.url.to_s)
      keys = uri.query.split('&').map{ |param| param.match(/(.*)=/)[1] }
      keys.should include('key1')
      keys.should include('key2')
    end

    it 'authenticates request' do
      transport.legacize_request
      req = transport.request
      req['authorization'].should_not be(nil)
    end

    it 'posts if there is a body' do
      transport.body = 'foo'
      transport.send(:request_method).should == Net::HTTP::Post
    end

    it 'posts if there is a query parameter' do
      transport.query_params = { :foo => 'bar' }
      transport.send(:request_method).should == Net::HTTP::Post
    end

    it 'gets if there is no body or query parameter' do
      transport.send(:request_method).should == Net::HTTP::Get
    end
  end
end
