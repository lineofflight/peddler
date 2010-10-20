require 'spec_helper'

module Peddler
  module Handlers    
    describe TabDelimitedHandler do
      it "parses tab-delimited text" do
        text = Peddler::Handlers::TabDelimitedHandler.decode_response("title\tautor\nA Thousand Plateaus\tGilles Deleuze\n")
        text[0].title.should == 'A Thousand Plateaus'
      end
    end
  end
end 
