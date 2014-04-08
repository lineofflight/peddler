require 'peddler/csv_parser'
require 'peddler/xml_parser'

module Peddler
  # @api private
  module Parser
    def self.parse(res)
      # Don't parse if there's no body
      return res unless res.body

      case res.headers['Content-Type']
      when 'text/xml'
        XMLParser.new(res)
      when 'application/octet-stream'
        CSVParser.new(res)
      else
        raise NotImplementedError
      end
    end
  end
end
