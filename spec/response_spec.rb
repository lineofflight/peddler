require_relative 'spec_helper'

module Peddler
  describe Response do
    let(:res) do
      Response.new(Struct.new(:body).new('<foo>bar</foo>'))
    end

    it 'parses response body into Ruby' do
      res.to_hash.must_be_kind_of Hash
    end
  end
end
