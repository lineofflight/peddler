# frozen_string_literal: true

require "peddler/types/shipping_v2/unmanifested_carrier_information"

module Peddler
  module Types
    module ShippingV2
      # A list of UnmanifestedCarrierInformation
      class UnmanifestedCarrierInformationList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| UnmanifestedCarrierInformation.parse(item) })
          end
        end
      end
    end
  end
end
