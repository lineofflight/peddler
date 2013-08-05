require_relative 'spec_helper'

module Peddler
  describe Service do
    before do
      @klass = Class.new(Service)
      @service = @klass.new('US')
    end

    it 'configures the endpoint path' do
      @klass.path('Foo')
      @service.endpoint.must_match(/Foo$/)
    end

    it 'has a User-Agent header' do
      @service.connection.data[:headers].wont_be_empty
    end

    it 'gets the service status' do
      @service.configure(aws_access_key_id:    'foo',
                         aws_secret_access_key: 'bar',
                         seller: 'baz')
      @service.status.must_match(/GREEN|YELLOW|RED/)
    end
  end
end
