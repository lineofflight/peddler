require_relative '../spec_helper'

module Peddler
  describe Products do
    let(:service) { Products.new 'US' }

    it 'has an endpoint' do
      service.endpoint.must_include 'Products/2011-10-01'
    end

    it 'gets the service status' do
      service.configure key:    'foo',
                        secret: 'bar',
                        seller: 'baz'
      service.status.must_match(/GREEN|YELLOW|RED/)
    end
  end
end
