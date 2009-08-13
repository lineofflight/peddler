require File.join(File.dirname(__FILE__), "/../spec_helper") 

module Peddler
  module Reports
    describe UnshippedOrdersReport do
      before(:each) do
        @transport = Peddler::Transport.new
        @transport.modernize_request
        @transport.stub!(:execute_request).and_return("<?xml version=\"1.0\"?>\n<Response xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://merchant-query.amazon.com/query/schema/MerchantQueryResponses.xsd\"><Report><ReportID>2597613290</ReportID><DownloadType>_GET_FLAT_FILE_ACTIONABLE_ORDER_DATA_</DownloadType><StartDate>2009-08-05T19:54:31+00:00</StartDate><EndDate>2009-08-12T19:54:31+00:00</EndDate><Scheduled>false</Scheduled><ReportStatus>_SUBMITTED_</ReportStatus><SubmittedDate>2009-08-12T19:54:31+00:00</SubmittedDate></Report></Response>")
        @report = Peddler::Reports::UnshippedOrdersReport.new(@transport)
      end
    
      it "should add generate a request" do
        @report.id.should == "2597613290"
        @report.status.should == "_SUBMITTED_"
      end
    end
  end
end 
