require File.join(File.dirname(__FILE__), '/../spec_helper') 

module Peddler
  
  describe Transport do 
    
    before(:each) do
      @transport = Peddler::Transport.new
      @transport.username = 'user'
      @transport.password = 'secret'
      @transport.region = :us
    end
    
    it 'should switch regions' do
      @transport.legacize_request
      @transport.region = :uk
      @transport.url.host.should == 'secure.amazon.co.uk'
    end
    
    it 'should raise error when region is invalid' do
      lambda { @transport.region = 'foo' }.should raise_error(PeddlerError)
    end
    
    it 'should add path to legacy URL' do
      @transport.legacize_request
      @transport.path << 'foo'
      @transport.url.to_s.should == 'https://secure.amazon.com/exec/panama/seller-admin/foo'
    end
    
    it 'should add path to modern URL' do
      @transport.modernize_request
      @transport.path << 'foo'
      @transport.url.to_s.should == 'https://secure.amazon.com/query/foo?Service=MerchantQueryService'
    end
    
    it 'should add query parameters to the modern URL' do
      @transport.modernize_request
      @transport.query_params['key1'] = 'val1'
      @transport.query_params['key2'] = 'val2'
      @transport.url.to_s.should == 'https://secure.amazon.com/query/?key1=val1&key2=val2&Service=MerchantQueryService'
    end
    
    it 'should authenticate request' do
      @transport.legacize_request
      req = @transport.request
      req['authorization'].should_not be(nil)
    end
    
    it 'should post if there is a body' do
      @transport.body = 'foo'
      @transport.send(:request_method).should == Net::HTTP::Post
    end
    
    it 'should post if there is a query parameter' do
      @transport.query_params = { :foo => 'bar' }
      @transport.send(:request_method).should == Net::HTTP::Post
    end
    
    it 'should get if there is no body or query parameter' do
      @transport.send(:request_method).should == Net::HTTP::Get
    end
  end
   
end 
 