require_relative '../spec_helper'

module Peddler
  describe Service do
    it 'requires a valid locale' do
      -> { Service.new('foo') }.must_raise BadLocale
    end

    it 'requires a seller' do
      -> { Service.new('US').seller }.must_raise MissingSeller
    end

    it 'does not implement an endpoint' do
      -> { Service.new('US').endpoint }.must_raise NotImplementedError
    end
  end
end
