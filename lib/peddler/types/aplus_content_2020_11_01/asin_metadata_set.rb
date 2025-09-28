# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/asin_metadata"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module AplusContent20201101
      # The set of ASIN metadata.
      class AsinMetadataSet < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| AsinMetadata.parse(item) }) : new
          end
        end
      end
    end
  end
end
