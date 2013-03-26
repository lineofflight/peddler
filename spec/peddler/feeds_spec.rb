require_relative '../spec_helper'

module Peddler
  describe Feeds do
    let(:service) { Feeds.new('US') }

    it 'gets the service status' do
      service.configure key:    'foo',
                        secret: 'bar',
                        seller: 'baz'
      service.status.must_match(/GREEN|YELLOW|RED/)
    end
  end
end
