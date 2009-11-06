require File.join(File.dirname(__FILE__), "/../spec_helper") 
module Peddler
  module Handlers
    describe XMLHandler do
      it "should parse XML" do
        xml = Peddler::Handlers::XMLHandler.decode_response("<Reports> <Report>reportstarttime=08-13-2009:06-16-06 reportendtime=12-31-1969:16-00-00 reportid=2599221990 </Report></Reports>")
        statuses = Peddler::Handlers::XMLHandler.parse_legacy(xml)
        statuses[0].id.should == "2599221990"
      end
    end
    
    describe TabDelimitedHandler do
      it "should parse tab-delimited text" do
        text = Peddler::Handlers::TabDelimitedHandler.decode_response("title\tautor\nA Thousand Plateaus\tGilles Deleuze\n")
        text[0].title.should == "A Thousand Plateaus"
      end
    end
  end
end 
