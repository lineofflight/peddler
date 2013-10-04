require 'peddler/request'
require 'mws/feeds/parsers/feed'

module MWS
  module Feeds
    module Requests
      class Feed < ::Peddler::Request
        def submit(content, type, options = {})
          self.body = content
          set_content_type
          parameters(:submit_feed)
            .update(feed_type: type)
            .update(options)
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def set_content_type
          headers['Content-Type'] =
            if body.start_with?('<?xml')
              'text/xml; charset=ISO-8859-1'
            else
              case client.default_country
              when 'JP'
                'text/tab-separated-values; charset=Shift_JIS'
              when 'CN'
                'text/tab-separated-values; charset=UTF-16'
              else
                'text/tab-separated-values; charset=ISO-8859-1'
              end
            end
        end
      end
    end
  end
end
