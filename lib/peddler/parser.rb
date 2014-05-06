require 'peddler/flat_file_parser'
require 'peddler/xml_parser'

module Peddler
  # @api private
  module Parser
    class << self
      # The inevitable messiness of massaging data produced by a motley army of
      # Amazon developers
      def parse(res, encoding = 'ISO-8859-1')
        # Don't parse if there's no body
        return res unless res.body

        content_type = res.headers['Content-Type']
        if content_type.start_with?('text/xml')
          XMLParser.new(res)
        else
          # Amazon returns a variety of content types for flat files, so we
          # simply assume that anything not XML is a flat file rather than code
          # defensively and check content type again.
          FlatFileParser.new(res, encoding)
        end
      end
    end
  end
end
