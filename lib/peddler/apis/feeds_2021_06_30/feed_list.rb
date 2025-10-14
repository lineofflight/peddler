# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class Feeds20210630
      # A list of feeds.
      class FeedList < Array
        class << self
          def parse(array)
            new(array.map { |item| Feed.parse(item) })
          end
        end
      end
    end
  end
end
