require_relative '../spec_helper'

module Peddler
  describe FulfillmentOutboundShipment do
    let(:service) { FulfillmentOutboundShipment.new('US') }

    it 'configures the endpoint path' do
      service.endpoint.must_match(/FulfillmentOutboundShipment/)
    end

    it 'gets the service status' do
      service.configure key:    'foo',
                        secret: 'bar',
                        seller: 'baz'
      service.status.must_match(/GREEN|YELLOW|RED/)
    end
  end
end
