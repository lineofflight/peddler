require 'spec_helper'

module Peddler
  module Reports
    describe UnshippedOrdersReport do
      let(:transport) do
        transport = Peddler::Transport.new
        transport.modernize_request
        transport.stub!(:execute_request).and_return('<?xml version="1.0"?>\n<Response xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://merchant-query.amazon.com/query/schema/MerchantQueryResponses.xsd"><Report><ReportID>2597613290</ReportID><DownloadType>_GET_FLAT_FILE_ACTIONABLE_ORDER_DATA_</DownloadType><StartDate>2009-08-05T19:54:31+00:00</StartDate><EndDate>2009-08-12T19:54:31+00:00</EndDate><Scheduled>false</Scheduled><ReportStatus>_SUBMITTED_</ReportStatus><SubmittedDate>2009-08-12T19:54:31+00:00</SubmittedDate></Report></Response>')
        transport
      end

      let(:report) { Peddler::Reports::UnshippedOrdersReport.new(transport) }

      it 'generates a request' do
        report.id.should == '2597613290'
        report.status.should == '_SUBMITTED_'
      end

      it 'updates status' do
        transport.stub!(:execute_request).and_return('<?xml version="1.0"?>\n<Response xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://merchant-query.amazon.com/query/schema/MerchantQueryResponses.xsd"><ReportsList><Report><ReportID>2893967048</ReportID><DownloadType>_GET_FLAT_FILE_ACTIONABLE_ORDER_DATA_</DownloadType><StartDate>2010-01-04T00:00:00+00:00</StartDate><EndDate>2010-01-12T00:00:00+00:00</EndDate><Scheduled>false</Scheduled><ReportStatus>_SUBMITTED_</ReportStatus><SubmittedDate>2010-01-11T06:02:40+00:00</SubmittedDate></Report></ReportsList></Response>')
        report.status!.should == '_SUBMITTED_'
      end
    end
  end
end 
