# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/label_format_option"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The available label formats.
      class AvailableFormatOptionsForLabel < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| LabelFormatOption.parse(item) }) : new
          end
        end
      end
    end
  end
end
