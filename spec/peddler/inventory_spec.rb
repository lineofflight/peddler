require File.join(File.dirname(__FILE__), "/../spec_helper") 

module Peddler
  
  module Inventory
    
    describe Queue do

      it "should show queue count" do
        transport = Peddler::Transport.new
        transport.legacize_request
        transport.stub!(:execute_request).and_return("<PendingUploadsCount>1</PendingUploadsCount>")
        Peddler::Inventory::Queue.count(transport).should == 1
      end

    end
    
    describe Batch do 
    
      before(:each) do
        @transport = Peddler::Transport.new
        @transport.legacize_request
        @inventory = Peddler::Inventory::Batch.new(@transport)
        @item = Peddler::Inventory::Item.new :product_id => "1234567890",
                                           :price => 100.00,
                                           :sku => "FOO-SKU",
                                           :quantity => 10
      end
      
      it "should add items to batch" do
        @inventory.batch.size.should == 0
        @inventory << @item
        @inventory.batch.size.should == 1
      end
    
      it "should generate an upload file" do
        @inventory << @item
        @inventory.file_content.should == "product-id\tproduct-id-type\titem-condition\tprice\tsku\tquantity\tadd-delete\twill-ship-internationally\texpedited-shipping\titem-note\titem-is-marketplace\tfulfillment-center-id\titem-name\titem-description\tcategory1\timage-url\tshipping-fee\tbrowse-path\tstorefront-feature\tboldface\tasin1\tasin2\tasin3\r\n1234567890\t\t\t100.0\tFOO-SKU\t10\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\r\n"
      end
    
      it "should generate a modify-only upload file" do
        @inventory << @item
        @inventory.file_content(:short).should == "sku\tprice\tquantity\r\nFOO-SKU\t100.0\t10\r\n"
      end
    
      it "should generate default headers for uploading" do
        params = @inventory.defaultize :file_format => "UIEE",
                                       :enable_expedited_shipping => "N"
        params[:method].should be_nil
        params[:upload_for].should == "Marketplace"
        params[:email].should == "Y"
        params[:file_format].should == "UIEE"
        params["enable-expedited-shipping"].should == "N"
        params[:enable_expedited_shipping].should be_nil
      end
    
      it "should upload batch" do
        @transport.stub!(:execute_request).and_return("<BatchID>2585199250</BatchID>")
        @inventory.upload.should == true
        @inventory.id.should == "2585199250"
      end
      
      it "should raise error if a subsequent upload is attempted" do
        @transport.stub!(:execute_request).and_return("<BatchID>2585199250</BatchID>")
        @inventory.upload.should == true
        @inventory.id.should_not == nil
        lambda { @inventory.upload }.should raise_error(PeddlerError)
      end
      
    end
  
  end
  
end 
