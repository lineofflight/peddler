# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/asin_metadata"

module Peddler
  module Types
    module AplusContent20201101
      # The set of ASIN metadata.
      class AsinMetadataSet < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| AsinMetadata.parse(item) })
          end
        end
      end
    end
  end
end
