require 'spec_helper'

module MWS
  describe Endpoint do
    before do
      @endpoint = Endpoint.new 'US'
    end

    it 'requires a valid locale' do
      expect { Endpoint.new 'foo' }.to raise_error BadLocale
    end

    describe '#key' do
      it 'requires key to have been set' do
        expect { @endpoint.key }.to raise_error MissingKey
      end
    end

    describe '#secret' do
      it 'requires secret to have been set' do
        expect { @endpoint.secret }.to raise_error MissingSecret
      end
    end

    describe '#seller_id' do
      it 'requires seller id to have been set' do
        expect { @endpoint.seller_id }.to raise_error MissingSellerId
      end
    end
  end
end
