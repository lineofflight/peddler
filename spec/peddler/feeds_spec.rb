require File.join(File.dirname(__FILE__), "/../spec_helper") 

module Peddler
  module Feeds
    module OrderFulfillment
      describe Batch do
        before(:each) do
          @transport = Peddler::Transport.new
          @transport.modernize_request
          @feed = Peddler::Feeds::OrderFulfillment::Batch.new(@transport)
          @fulfilled_order = Peddler::Feeds::OrderFulfillment::Item.new :order_id  => "123-1234567-1234567",
                                                                 :ship_date => Date.parse("2009-08-11").to_s
        end
      
        it "should add items to batch" do
          @feed.batch.size.should == 0
          @feed << @fulfilled_order
          @feed.batch.size.should == 1
        end
    
        it "should create content for upload" do
          @feed << @fulfilled_order
          @feed.file_content.should == "order-id\torder-item-id\tquantity\tship-date\tcarrier-code\tcarrier-name\ttracking-number\tship-method\r\n123-1234567-1234567\t\t\t2009-08-11\t\t\t\t\r\n"
        end
  
        it "should upload" do
          @feed.id.should == nil
          @transport.stub!(:execute_request).and_return('<Response xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://merchant-query.amazon.com/query/schema/MerchantQueryResponses.xsd"><Upload> <UploadId>130895733</UploadId><UploadType>_POST_FLAT_FILE_FULFILLMENT_DATA_</UploadType><UploadStatus>_SUBMITTED_</UploadStatus><SubmittedDate>2007-04-05T00:34:00+0000</SubmittedDate></Upload></Response>')
          @feed.upload
          @feed.id.should == "130895733"
          @feed.status.should == "_SUBMITTED_"
        end
        
        it "should refresh status" do
          @transport.stub!(:execute_request).and_return('<Response xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://merchant-query.amazon.com/query/schema/MerchantQueryResponses.xsd"><Upload> <UploadId>130895733</UploadId><UploadType>_POST_FLAT_FILE_FULFILLMENT_DATA_</UploadType><UploadStatus>_SUBMITTED_</UploadStatus><SubmittedDate>2007-04-05T00:34:00+0000</SubmittedDate></Upload></Response>')
          @feed.upload
          @transport.stub!(:execute_request).and_return('<Response xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://merchant-query.amazon.com/query/schema/MerchantQueryResponses.xsd"><UploadsStatusList><Upload><UploadId>130895733</UploadId><UploadType>_POST_FLAT_FILE_FULFILLMENT_DATA_</UploadType><UploadStatus>_IN_PROGRESS_</UploadStatus><SubmittedDate>2007-04-05T00:34:00+0000</SubmittedDate><StartedProcessingDate>2007-04-05T00:39:00+0000</StartedProcessingDate></Upload></UploadsStatusList></Response>')
          @feed.status.should == "_SUBMITTED_"
          @feed.status!.should == "_IN_PROGRESS_"
          @transport.stub!(:execute_request).and_return('<Response xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://merchant-query.amazon.com/query/schema/MerchantQueryResponses.xsd"><UploadsStatusList><Upload><UploadId>130895733</UploadId><UploadType>_POST_FLAT_FILE_FULFILLMENT_DATA_</UploadType><UploadStatus>_DONE_</UploadStatus><SubmittedDate>2007-04-05T00:34:00+0000</SubmittedDate><StartedProcessingDate>2007-04-05T00:39:00+0000</StartedProcessingDate><CompletedProcessingDate>2007-04-05T01:02:00+0000</CompletedProcessingDate><MessagesProcessed>2</MessagesProcessed><MessagesSuccessful>2</MessagesSuccessful><MessagesWithErrors>0</MessagesWithErrors><MessagesWithWarnings>0</MessagesWithWarnings><RelatedDownloadsList><Download><DownloadId>3404021</DownloadId><DownloadType>FeedSummaryReport</DownloadType><RelatedReferenceId>4307285844</RelatedReferenceId><AvailableDate>2009-04-24T23:47:24+00:00</AvailableDate><Acknowledged>FALSE</Acknowledged></Download></RelatedDownloadsList></Upload></UploadsStatusList></Response>')
          @feed.status!.should == "_DONE_"
          @feed.download.id.should == "3404021"
          @feed.download.available_at.to_s.should == "Sat Apr 25 00:47:24 +0100 2009"
        end
      end
    end
    
    module OrderCancellation
      describe Batch do
        before(:each) do
          @transport = Peddler::Transport.new
          @transport.modernize_request
          @feed = Peddler::Feeds::OrderCancellation::Batch.new(@transport)
          @cancelled_order = Peddler::Feeds::OrderCancellation::Item.new :order_id  => "123-1234567-1234567"
        end
        
        it "should add items to batch" do
          @feed.batch.size.should == 0
          @feed << @cancelled_order
          @feed.batch.size.should == 1
        end
        
        it "should create content for upload" do
          @feed << @cancelled_order
          @feed.file_content.should == "TemplateType=OrderCancellation  Version=1.0/1.0.3 This row for Amazon.com use only.  Do not modify or delete.\r\norder-id\tcancellation-reason-code\tamazon-order-item-code\r\n123-1234567-1234567\t\t\r\n"
        end
      end
    end
  end
end 
