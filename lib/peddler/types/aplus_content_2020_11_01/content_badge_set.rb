# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module AplusContent20201101
      # The set of content badges.
      class ContentBadgeSet < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
