require File.join(File.dirname(__FILE__), "/../spec_helper") 

module Peddler
  module Refunds
    describe Batch do 
      before(:each) do
        @transport = Peddler::Transport.new
        @transport.legacize_request
        @refunds = Peddler::Refunds::Batch.new(@transport)
        @refund = Peddler::Refunds::Item.new :order_id => "123-1234567-1234567",
                                             :payments_transaction_id => "12341234567890",
                                             :refund_amount => 10.00,
                                             :reason => "CouldNotShip",
                                             :message => "With our apologies"
      end
      
      it "should add items to batch" do
        @refunds.batch.size.should == 0
        @refunds << @refund
        @refunds.batch.size.should == 1
      end
    
      it "should generate an upload file" do
        @refunds << @refund
        @refunds.file_content.should == "order-id\tpayments-transaction-id\trefund-amount\treason\tmessage\r\n123-1234567-1234567\t12341234567890\t10.0\tCouldNotShip\tWith our apologies\r\n"
      end
      
      it "should upload batch" do
        @transport.stub!(:execute_request).and_return("<Success>SUCCESS</Success>")
        @refunds << @refund
        @refunds.upload.should == true
      end
    end
  end
end
