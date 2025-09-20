# frozen_string_literal: true

require "peddler/types/shipment_invoicing_v0/payment_information"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # List of payment transactions
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
