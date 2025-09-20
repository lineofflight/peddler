# frozen_string_literal: true

require "peddler/types/shipping_v2/active_account"

module Peddler
  module Types
    module ShippingV2
      # A list of ActiveAccount
      class ActiveAccounts < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ActiveAccount.parse(item) })
          end
        end
      end
    end
  end
end
