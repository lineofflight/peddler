# encoding: utf-8

module Peddler
  module Handlers
    class XMLHandler

      # Parses legacy responses to queries on statuses of generated reports and inventory uploads.
      def self.parse_legacy(hash)
        if hash['Batches']
          [hash['Batches']['Batch']].flatten.collect  { |input| Peddler::LegacyReports::UploadStatus.new(input) }
        elsif hash['Reports']
          [hash['Reports']['Report']].flatten.collect { |input| Peddler::LegacyReports::ReportStatus.new(input) }
        end
      end
    end

    class TabDelimitedHandler
      # Decodes tab-delimited content into an array of OpenStruct objects. It
      # assumes first line contains parameter names.
      def self.decode_response(res, &block)

        # A hack: ignore invalid utf-8 byte sequences in response
        if res.respond_to?(:valid_encoding?) && !res.valid_encoding?
          res = res.unpack('C*').pack('U*')
        end

        if block_given?
          res.scan(/[^\n]+/, &block)
        else
          lines = res.split("\n")
          if lines.size > 1
            params = lines[0].split("\t").collect{ |value| value.gsub(/-/, '_') }
            params_size = params.size
            (1..(lines.size - 1)).collect do |line_key|
              values = lines[line_key].split("\t")
              data = (0..(params_size - 1)).inject({}) { |memo, key| memo.merge( { params[key] => values[key] } ) }
              OpenStruct.new(data)
            end
          else
            res
          end
        end
      end
    end
  end
end
