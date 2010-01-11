module Peddler
  
  # This module generates and downloads unshipped order reports.
  # I decided to keep this out of Peddler::LegacyReports because the API is
  # quite different.
  module Reports
    
    # This is an unshipped orders report. It is very similar to the feed 
    # objects, so I'm just porting over the class.
    class UnshippedOrdersReport < Peddler::Feeds::Feed
      alias         :unshipped_orders :batch
      attr_accessor :starts_at, :ends_at, :scheduled
      
      MAPPED_PARAMS = {
        "ReportID"                  => "id",
        "StartDate"                 => "starts_at",
        "EndDate"                   => "ends_at",
        "DownloadType"              => "type",
        "Scheduled"                 => "scheduled",
        "ReportStatus"              => "status",
        "SubmittedDate"             => "submitted_at",
        "StartedProcessingDate"     => "started_processing_at",
        "CompletedProcessingDate"   => "completed_processing_at",
        "CompletedProcesssingDate"  => "completed_processing_at"}
      
      # Creates new unshipped order report. It will send a request to 
      # Amazon to generate the report if the report ID is not already set.
      def initialize(transport, params={})
        super(transport)
        params.each_pair{ |key, value| self.send "#{key}=", value }
        @starts_at ||= (Date.today - 7).strftime("%Y-%m-%dT00:00:00-00:00")
        @ends_at ||= (Date.today + 1).strftime("%Y-%m-%dT00:00:00-00:00")
        #@type ||= "_GET_CONVERGED_FLAT_FILE_ACTIONABLE_ORDER_DATA_"
        @type ||= "_GET_FLAT_FILE_ACTIONABLE_ORDER_DATA_"
        if @id.nil?
          generate_report
        end
        self
      end
      
      private
      
      def refresh_status
        @transport.modernize_request
        @transport.query_params.merge!({
          "Action"   => "reportStatus",
          "reportId" => @id})
        res = @transport.execute_request
        process_response(res)
      end
      
      def generate_report
        @transport.modernize_request
        @transport.query_params.merge!({
          "Action"       => "generateReport",
          "startDate"    => @starts_at,
          "endDate"      => @ends_at,
          "downloadType" => @type})
        res = @transport.execute_request
        process_response(res)
      end
      
      def process_response(res)
        hash = Hash.from_xml(res)
        report = Hash.from_xml(res)['Response']['Report'] || Hash.from_xml(res)['Response']['ReportsList']['Report']
        report.each_pair do |key, value|
          if key == "ListOfDownloads"
            @download = Peddler::Feeds::Download.new(@transport, value['Download'])
            @batch = Peddler::Handlers::TabDelimitedHandler.decode_response(@download.to_s)
          else
            self.send "#{MAPPED_PARAMS[key]}=", value
          end
        end
      end
    end
    
    # This is an unshipped order.
    class Item
      attr_accessor :order_id, :order_item_id, :quantity, :ship_date, :carrier_name, :tracking_number, :ship_method
      attr_reader   :carrier_code

      def initialize(params={})
        params.each_pair{ |key, value| send("#{key}=", value) }
      end
      
      # Validates when setting carrier code.
      def carrier_code=(carrier_code)
        @carrier_code = carrier_code if %w{USPS UPS FedEx other}.include?(carrier_code)
      end
      
      # Outputs a formatted line for the tab-delimited upload file.
      def to_s
        "#{@order_id}\t#{@order_item_id}\t#{@quantity}\t#{@ship_date}\t#{@carrier_code}\t#{@carrier_name}\t#{@tracking_number}\t#{@ship_method}\r\n"
      end
    end
  end
end