# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class AplusContent20201101
      # A list of locale-keyed accessibility descriptions. At least one entry is required for video assets.
      class DescriptionList < Array
        class << self
          def parse(array)
            new(array.map { |item| Description.parse(item) })
          end
        end
      end
    end
  end
end
