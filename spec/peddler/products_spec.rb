require_relative '../spec_helper'

module Peddler
  describe Products do
    let(:request) { Products.new 'US' }

    it 'has an endpoint' do
      request.endpoint.must_include 'Products/2011-10-01'
    end

    it 'has default parameters' do
      %w(key secret seller).each do |attr|
        request.send "#{attr}=", 'foo'
      end

      request.params.wont_be_empty
    end
  end
end
