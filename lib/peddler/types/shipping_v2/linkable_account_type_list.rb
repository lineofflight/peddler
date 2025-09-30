# frozen_string_literal: true

require "peddler/types/shipping_v2/linkable_account_type"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of LinkableAccountType
      class LinkableAccountTypeList < Array
        class << self
          def parse(array)
            new(array.map { |item| LinkableAccountType.parse(item) })
          end
        end
      end
    end
  end
end
