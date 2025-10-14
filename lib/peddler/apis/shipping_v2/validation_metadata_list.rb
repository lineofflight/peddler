# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # A list of ValidationMetadata
      class ValidationMetadataList < Array
        class << self
          def parse(array)
            new(array.map { |item| ValidationMetadata.parse(item) })
          end
        end
      end
    end
  end
end
