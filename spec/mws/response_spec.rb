require 'spec_helper'

module MWS
  describe Response do
    before do
      @http = double 'Faraday::Response'
      @http.stub!(:body).and_return(
        '<?xml version="1.0" ?>
         <children>
         <child>
         <name>foo</name>
         </child>
         <child>
         <name>bar</name>
         </child>
         </children>'.gsub />\s+</, '><')
      @http.stub!(:status).and_return 200
      @response = Response.new @http
      @child_name = @response.xml.children.first.name
    end

    describe '#find' do
      it 'returns an Array of matches' do
        @response.find(@child_name).should_not be_empty
      end

      it 'yields matches to a block' do
        yielded = false
        @response.find(@child_name) { yielded = true }
        yielded.should be_true
      end
    end

    describe '#to_hash' do
      it 'casts response to a hash' do
        @response.to_hash.should be_a Hash
      end
    end

    describe '#valid?' do
      context 'when HTTP status is OK' do
        it 'returns true' do
          @response.should be_valid
        end
      end

      context 'when HTTP status is not OK' do
        before do
          @response.instance_variable_set :@status, 403
        end

        it 'returns false' do
          @response.should_not be_valid
        end
      end
    end
  end
end
