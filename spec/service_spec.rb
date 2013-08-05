require_relative 'spec_helper'

module Peddler
  describe Service do
    before do
      @klass = Class.new(Service)
      @service = @klass.new(*::MWS_KEYS.values)
    end

    it 'configures the URL path' do
      @klass.path('Foo')
      @service.endpoint.must_match(/Foo$/)
    end

    it 'has a User Agent' do
      @service.connection.data[:headers].wont_be_empty
    end

    it 'returns a marketplace' do
      @service.marketplace_id.wont_be_empty
    end

    it 'finds a marketplace' do
      @service.find_marketplace_id('US').wont_equal @service.find_marketplace_id('GB')
    end
  end
end
