require_relative '../spec_helper'

module Peddler
  describe FulfillmentInventory do
    let(:service) { FulfillmentInventory.new('US') }

    it 'configures the endpoint path' do
      service.endpoint.must_match(/FulfillmentInventory/)
    end

    it 'gets the service status' do
      service.configure key:    'foo',
                        secret: 'bar',
                        seller: 'baz'
      service.status.must_match(/GREEN|YELLOW|RED/)
    end
  end
end
