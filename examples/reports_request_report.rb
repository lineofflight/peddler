$:.unshift File.expand_path('../../lib', __FILE__)

require 'nokogiri'
require 'pry'
require 'yaml'
require 'peddler/reports'

class Report
  class << self
    def generate
      res = reports.get query: {
        'Action'     => 'RequestReport',
        'ReportType' => '_GET_FLAT_FILE_ACTIONABLE_ORDER_DATA_',
        'StartDate'  => Time.parse((Date.today - 30).to_s).utc.iso8601 }

      parse(res).first
    end

    def recent
      parse reports.get query: {
        'Action'     => 'GetReportRequestList',
        'ReportType' => '_GET_FLAT_FILE_ACTIONABLE_ORDER_DATA_' }
    end

    private

    def credentials
      YAML.load_file File.expand_path '../amazon.yml', __FILE__
    end

    def parse(res)
      doc = Nokogiri::XML(res.body)
      doc.remove_namespaces!

      doc.xpath('//ReportRequestInfo').map { |node| new node }
    end

    def reports
      @reports ||= begin
        Peddler::Reports.new('DE').tap do |reports|
          reports.configure credentials
        end
      end
    end
  end

  attr :doc

  def initialize(doc)
    @doc = doc
  end

  def generated_id
    @doc.at('GeneratedReportId').text rescue nil
  end

  def request_id
    @doc.at('ReportRequestId').text
  end

  def status
    @doc.at('ReportProcessingStatus').text
  end
end

binding.pry
