# frozen_string_literal: true

require "peddler/types/shipping_v1/label_result"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV1
      # A list of label results
      class LabelResultList < Array
        class << self
          def parse(array)
            new(array.map { |item| LabelResult.parse(item) })
          end
        end
      end
    end
  end
end
