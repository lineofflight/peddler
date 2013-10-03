require 'peddler/request'
require 'mws/feeds/parsers/feed'

module MWS
  module Feeds
    module Requests
      class Feed < ::Peddler::Request
        def submit(content, type, options = {})
          set_body(content)
          parameters(:submit_feed)
            .update(feed_type: type)
            .update(options)
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def set_body(content)
          self.body = content

          headers['Content-Type'] =
            if body.start_with?('<?xml')
              'text/xml'
            else
              case client.default_country
              when 'JP'
                'text/tab-separated-values; charset=Shift_JIS'
              when 'CN'
                'text/tab-separated-values; charset=UTF-16'
              else
                'text/tab-separated-values; charset=iso-8859-1'
              end
            end
        end

        private

        def xml_payload
          super.first
        end
      end
    end
  end
end
