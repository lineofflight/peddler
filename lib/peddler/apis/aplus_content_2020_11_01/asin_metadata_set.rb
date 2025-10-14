# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class AplusContent20201101
      # The set of ASIN metadata.
      class ASINMetadataSet < Array
        class << self
          def parse(array)
            new(array.map { |item| ASINMetadata.parse(item) })
          end
        end
      end
    end
  end
end
