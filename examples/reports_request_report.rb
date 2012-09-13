$:.unshift File.expand_path('../../lib', __FILE__)

require 'nokogiri'
require 'pry'
require 'yaml'
require 'peddler/reports'

req = Peddler::Reports.new 'DE'
req.configure YAML.load_file File.expand_path '../amazon.yml', __FILE__

req.get query: {
  'Action'     => 'RequestReport',
  'ReportType' => '_GET_FLAT_FILE_ACTIONABLE_ORDER_DATA_'
}

get_status = -> {
  res = req.get query: {
    'Action'                => 'GetReportRequestList',
    'ReportTypeList.Type.1' => '_GET_FLAT_FILE_ACTIONABLE_ORDER_DATA_'
  }

  doc = Nokogiri::XML(res.body)
  doc.remove_namespaces!

  doc.xpath('//ReportRequestInfo/ReportProcessingStatus').first.text
}

binding.pry
