require_relative '../spec_helper'

module Peddler
  describe Service do
    let(:service) { Service.new 'US' }

    it 'requires a valid locale' do
      -> { Service.new('foo') }.must_raise BadLocale
    end

    it 'requires a seller' do
      -> { Service.new('US').seller }.must_raise MissingSeller
    end

    it 'configures the endpoint path' do
      Service.path 'Foo'
      service.endpoint.must_match(/Foo$/)
      Service.path ''
    end

    it 'gets the service status' do
      service.configure key:    'foo',
                        secret: 'bar',
                        seller: 'baz'
      service.status.must_match(/GREEN|YELLOW|RED/)
    end
  end
end
