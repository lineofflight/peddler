require File.join(File.dirname(__FILE__), "/../spec_helper") 

module Peddler
  describe LegacyReports do
    before(:each) do
      @transport = Peddler::Transport.new
      @transport.legacize_request
    end
    
    it "should generate an order report" do  
      @transport.stub!(:execute_request).and_return("<Status>SUCCESS</Status>")
      res = Peddler::LegacyReports.generate(@transport, :order, :number_of_days => 30)
      res.should be_an_instance_of(Peddler::LegacyReports::Report)
    end
        
    it "should show most recent order reports" do
      @transport.stub!(:execute_request).and_return("<Reports> <Report>reportstarttime=07-23-2009:08-33-48 reportendtime=08-07-2009:08-33-48 reportid=1234567890 </Report></Reports>")
      report_status = Peddler::LegacyReports.latest(@transport, :order, :count => 1)[0]
      report_status.starts_at.should == "07-23-2009:08-33-48"
      report_status.id.should == "1234567890"
    end
    
    it "should show most recent uploads" do
      @transport.stub!(:execute_request).and_return("<Batches> <Batch>batchid=2586376232 status=Done dateandtime=08/07/2009 01:48:23 PDT activateditems=1020 numberofwarnings=0 itemsnotacivated=0 </Batch></Batches>")
      upload = Peddler::LegacyReports.latest(@transport, :upload, :count => 1)[0]
      upload.id.should == "2586376232"
      upload.status.should == "Done"
      upload.datetime.should == "08/07/2009 01:48:23 PDT"
      upload.activated_items.should == "1020"
      upload.number_of_warnings.should == "0"
      upload.items_not_activated.should == "0"
    end
  end
  
  module LegacyReports
    describe Report do 
      before(:each) do
        @transport = Peddler::Transport.new
        @transport.legacize_request
        @report = Peddler::LegacyReports::Report.new(@transport)
      end
      
      it "should download an inventory upload error log" do 
        @transport.stub!(:execute_request).and_return("Feed Processing Summary:\n\tNumber of records processed\t\t82\n\tNumber of records successful\t\t81\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n27\t1111111111\t8026\tError\tSeller is not authorized to list products in this category. For more details, see http://sellercentral.amazon.com/gp/errorcode/8026\n")
        
        @report.name = :upload
        @report.id = "1234567890"
      end
      
      it "should download an inventory upload error log" do
        @transport.stub!(:execute_request).and_return("Feed Processing Summary:\n\tNumber of records processed\t\t82\n\tNumber of records successful\t\t81\n\noriginal-record-number\tsku\terror-code\terror-type\terror-message\n27\t1111111111\t8026\tError\tSeller is not authorized to list products in this category. For more details, see http://sellercentral.amazon.com/gp/errorcode/8026\n")
        @report.name = :upload
        @report.id = "1234567890"
        @report.body.should =~ /Feed Processing Summary/
      end
      
      it "should retrieve an order report by id" do
        @transport.stub!(:execute_request).and_return("payments-status\torder-id\torder-item-id\tpayments-date\tpayments-transaction-id\titem-name\tlisting-id\tsku\tprice\tshipping-fee\tquantity-purchased\ttotal-price\tpurchase-date\tbatch-id\tbuyer-email\tbuyer-name\trecipient-name\tship-address-1\tship-address-2\tship-city\tship-state\tship-zip\tship-country\tspecial-comments\tupc\tship-method\n\t001-1234567-1234567\t12345678901234\t2009-07-23 08:59:03 PST\t\tFoo Bar\t000000000000\t1234567890\t10.00\t3.99\t1\t13.99\t2009-07-23 08:59:03 PST\t\tfoo@bar.com\tJOHN DOE\tJohn Doe\t1 MAIN ST\t\tNEW YORK\tNY\t10001-1000\tUS\t\t\tstandard\n")
        @report.name = :order
        @report.id = "1234567890"
        res = Peddler::Handlers::TabDelimitedHandler.decode_response(@report.body)
        res.size.should == 1
        res[0].order_id.should == "001-1234567-1234567"
        res[0].buyer_name.should == "JOHN DOE"
      end
    
      it "should retrieve an order report by report name" do
        @transport.stub!(:execute_request).and_return("payments-status\torder-id\torder-item-id\tpayments-date\tpayments-transaction-id\titem-name\tlisting-id\tsku\tprice\tshipping-fee\tquantity-purchased\ttotal-price\tpurchase-date\tbatch-id\tbuyer-email\tbuyer-name\trecipient-name\tship-address-1\tship-address-2\tship-city\tship-state\tship-zip\tship-country\tspecial-comments\tupc\tship-method\n\t001-1234567-1234567\t12345678901234\t2009-07-23 08:59:03 PST\t\tFoo Bar\t000000000000\t1234567890\t10.00\t3.99\t1\t13.99\t2009-07-23 08:59:03 PST\t\tfoo@bar.com\tJOHN DOE\tJohn Doe\t1 MAIN ST\t\tNEW YORK\tNY\t10001-1000\tUS\t\t\tstandard\n")
        @report.name = :order
        res = Peddler::Handlers::TabDelimitedHandler.decode_response(@report.body)
        res.size.should == 1
        res[0].order_id.should == "001-1234567-1234567"
        res[0].buyer_name.should == "JOHN DOE"
      end
      
      it "should retrieve an open listings liter report by id" do
        @transport.stub!(:execute_request).and_return("seller-sku\tquantity\nSKU-FOO\t14\n")
        @report.name = :open_listings_liter
        @report.id = "1234567890"
        res = Peddler::Handlers::TabDelimitedHandler.decode_response(@report.body)
        res.size.should == 1
        res[0].seller_sku.should == "SKU-FOO"
      end
    end
  end
end 
