# frozen_string_literal: true

require 'peddler/xml_parser'

module Peddler
  module Errors
    # @api private
    class Parser < XMLParser
      def message
        parse['Message']
      end

      def type
        parse['Type']
      end

      def code
        parse['Code']
      end

      private

      def find_data
        xml.dig('ErrorResponse', 'Error')
      end
    end
  end
end
