require_relative 'spec_helper'

module Peddler
  describe Orders do
    let(:service) { Orders.new('US') }

    it 'configures the endpoint path' do
      service.endpoint.must_match(/Orders/)
    end

    it 'gets the service status' do
      service.configure key:    'foo',
                        secret: 'bar',
                        seller: 'baz'
      service.status.must_match(/GREEN|YELLOW|RED/)
    end
  end
end
