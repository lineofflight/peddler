module Peddler
  module Handlers
    class XMLHandler
      # Decodes an XML response.
      def self.decode_response(res)
        XmlSimple.xml_in(res)
      end
      # Parses responses to uploads and status queries for feeds in Section 7 of the docs. Walks
      # through lists and returns an array of hashes.
      def self.parse(name, xml)
        name = name.to_s.capitalize
        list = xml["#{name}sStatusList"] || xml["#{name}sList"]
        if list
          list.collect { |s| parse_status(name, s) }
        else
          [ parse_status(name, xml) ]
        end
      end
      
      # Parses legacy responses to queries on statuses of generated reports and inventory uploads.
      def self.parse_legacy(xml)
        if xml["Batch"]
          xml["Batch"].collect  { |input| Peddler::LegacyReports::UploadStatus.new(input) }
        elsif xml["Report"]
          xml["Report"].collect { |input| Peddler::LegacyReports::ReportStatus.new(input) }
        end
      end
    protected
      def self.parse_status(name, xml)
        if xml[name]
          xml[name][0].inject({}) do |memo, pair|
            key, value = pair
            value[0] = Time.parse(value[0]) if key =~ /Date$/
            memo.merge!({ key => value[0] })
          end
        end
      end
    end
    
    class TabDelimitedHandler
      # Parses tab-delimited content, returning an array of OpenStruct objects corresponding to the rows in the former.
      def self.decode_response(res)
        lines = res.split("\n")
        if lines.size > 1
          params = lines[0].split("\t").collect{ |value| value.gsub(/-/, "_") }
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