# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/payment_information"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of various payment attributes related to this fulfillment order.
      class PaymentInformationList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| PaymentInformation.parse(item) })
          end
        end
      end
    end
  end
end
