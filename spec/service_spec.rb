require_relative 'spec_helper'

module Peddler
  describe Service do
    before do
      @klass = Class.new(Service)
      @service = Products.new(*::MWS_KEYS.values)
    end

    it 'configures the endpoint path' do
      @klass.path('Foo')
      @service.endpoint.must_match(/Foo$/)
    end

    it 'has a User Agent' do
      @service.connection.data[:headers].wont_be_empty
    end

    it 'gets the service status' do
      res = @service.get_service_status
      res['Status'].must_match(/GREEN|YELLOW|RED/)
    end
  end
end
