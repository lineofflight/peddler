module Peddler
  # This module contains methods to manage legacy reports -- anything that comes before section 7 in the API docs.
  module LegacyReports
    # Returns statuses of most recent reports in an array of openstructs.
    def self.latest(transport,name,params={})
      transport.legacize_request
      if name == :upload
        transport.path << "catalog-upload/get-batches"
        transport.headers[:number_of_batches] = params[:count] if params[:count]
      else
        transport.path << "manual-reports/get-report-status"
        transport.headers[:report_name] = name.to_s.camelize
        transport.headers[:number_of_reports] = params[:count] if params[:count]
      end
      res = transport.execute_request
      xml = Peddler::Handlers::XMLHandler.decode_response(res)
      Peddler::Handlers::XMLHandler.parse_legacy(xml)
    end
    
    # Requests a report to be generated. Returns the report instance if request is successful.
    def self.generate(transport,name,params={})
      transport.legacize_request
      transport.path << "manual-reports/generate-report-now"
      transport.headers[:report_name] = name.to_s.camelize
      transport.headers.merge!(params)
      res = transport.execute_request
      res =~ /SUCCESS/ ? Peddler::LegacyReports::Report.new(transport, name) : false
    end
    
    # A legacy report
    class Report
      attr_accessor :name, :id, :product_line, :frequency
      
      def initialize(transport, name=nil, params={})
        @transport, @name = transport, name
        params.each_pair{ |key, value| self.send "#{key}=", value }
      end
      
      def body
        return nil if @name == :upload && @id.nil?
        @body ||= download
      end
    
    private
      def download
        return false if @name.nil? && @id.nil?
        case @name.to_s
        when "upload"
          @transport.legacize_request
          @transport.path << "download/errorlog"
          @transport.headers["BatchID"] = @id
          @transport.execute_request
        else
          @transport.legacize_request
          @transport.path << "download/report"
          if @id.nil?
            @transport.headers[:report_name] = @name.to_s.camelize
            if @name == :preorder
              @transport.headers["productline"] = @product_line if @product_line
              @transport.headers["frequency"] = @frequency if @frequency
            end
          else
            @transport.headers["ReportID"] = @id
          end
          @transport.execute_request
        end
      end
    end
    
    class Status < OpenStruct
      def initialize(input)
        if input.kind_of? String
          hash = input.scan(/([a-z]+)=([^=]+)($| )/).inject({}){ |memo, value| memo.merge( { @keymap[value[0]] => value[1].strip }) }
        end
        super(hash)
      end
    
      def id
        @table[:id] || self.object_id
      end
    end
  
    class ReportStatus < Status
      def initialize(input)
        @keymap = {
          "reportstarttime" => "starts_at",
          "reportendtime"   => "ends_at",
          "reportid"        => "id"}
        super(input)
      end
    end
  
    class UploadStatus < Status
      def initialize(input)
        @keymap = {
          "status"            => "status",
          "batchid"           => "id",
          "numberofwarnings"  => "number_of_warnings",
          "activateditems"    => "activated_items",
          "itemsnotacivated"  => "items_not_activated",
          "itemsnotactivated" => "items_not_activated",
          "dateandtime"       => "datetime"}
        super(input)
      end
    end
  end
end