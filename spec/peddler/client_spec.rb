require File.join(File.dirname(__FILE__), "/../spec_helper") 

module Peddler
  
  describe Client do 
    
    before(:each) do
      @client = Peddler::Client.new :username => "seller@example.com",
                                    :password => "secret",
                                    :region   => "us"
    end
      
    it "should return a new inventory batch" do
      @client.new_inventory_batch.should be_an_instance_of(Peddler::Inventory::Batch)
    end
    
    it "should return a new inventory item" do
      @client.new_inventory_item.should be_an_instance_of(Peddler::Inventory::Item)
    end
    
    it "should return a new order fulfillment feed" do
      @client.new_order_fulfillment_feed.should be_an_instance_of(Peddler::Feeds::OrderFulfillment::Batch)
    end
    
    it "should return a new fulfilled order" do
      @client.new_fulfilled_order.should be_an_instance_of(Peddler::Feeds::OrderFulfillment::Item)
    end
    
    it "should return a new order cancellation feed" do
      @client.new_order_cancellation_feed.should be_an_instance_of(Peddler::Feeds::OrderCancellation::Batch)
    end
    
    it "should return a new cancelled order" do
      @client.new_cancelled_order.should be_an_instance_of(Peddler::Feeds::OrderCancellation::Item)
    end
    
    it "should return a new refund batch" do
      @client.new_refund_batch.should be_an_instance_of(Peddler::Refunds::Batch)
    end
    
    it "should return a new report" do
      @client.new_report(:foo).should be_an_instance_of(Peddler::LegacyReports::Report)
    end
    
  end
  
end 
