# frozen_string_literal: true

require "peddler/types/shipping_v2/linkable_account_type"

module Peddler
  module Types
    module ShippingV2
      # A list of LinkableAccountType
      class LinkableAccountTypeList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| LinkableAccountType.parse(item) })
          end
        end
      end
    end
  end
end
