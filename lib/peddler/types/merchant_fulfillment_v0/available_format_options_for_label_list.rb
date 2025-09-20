# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/label_format_option"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The available label formats.
      class AvailableFormatOptionsForLabelList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| LabelFormatOption.parse(item) })
          end
        end
      end
    end
  end
end
