# frozen_string_literal: true

require "peddler/types/feeds_2021_06_30/feed"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module Feeds20210630
      # A list of feeds.
      class FeedList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Feed.parse(item) }) : new
          end
        end
      end
    end
  end
end
