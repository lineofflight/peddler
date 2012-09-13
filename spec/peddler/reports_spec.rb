require_relative '../spec_helper'

module Peddler
  describe Reports do
    let(:service) { Reports.new 'US' }

    it 'gets the service status' do
      service.configure key:    'foo',
                        secret: 'bar',
                        seller: 'baz'
      service.status.must_match(/GREEN|YELLOW|RED/)
    end
  end
end
