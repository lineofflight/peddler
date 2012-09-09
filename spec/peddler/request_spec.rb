require_relative '../spec_helper'

module Peddler
  describe Request do
    it 'requires a valid locale' do
      -> { Request.new('foo') }.must_raise BadLocale
    end

    it 'requires a seller' do
      -> { Request.new('US').seller }.must_raise MissingSeller
    end

    it 'does not implement an endpoint' do
      -> { Request.new('US').endpoint }.must_raise NotImplementedError
    end
  end
end
