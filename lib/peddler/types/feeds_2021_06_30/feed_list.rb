# frozen_string_literal: true

require "peddler/types/feeds_2021_06_30/feed"

module Peddler
  module Types
    module Feeds20210630
      # A list of feeds.
      class FeedList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Feed.parse(item) })
          end
        end
      end
    end
  end
end
