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
        elsif content_type == 'application/octet-stream'
          FlatFileParser.new(res, encoding)
        else
          raise NotImplementedError
        end
      end
    end
  end
end
