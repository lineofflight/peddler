# frozen_string_literal: true

require "peddler/types/finances_v0/seller_review_enrollment_payment_event"

module Peddler
  module Types
    module FinancesV0
      # A list of information about fee events for the Early Reviewer Program.
      class SellerReviewEnrollmentPaymentEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| SellerReviewEnrollmentPaymentEvent.parse(item) })
          end
        end
      end
    end
  end
end
