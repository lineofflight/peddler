# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A list of information about fee events for the Early Reviewer Program.
      class SellerReviewEnrollmentPaymentEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| SellerReviewEnrollmentPaymentEvent.parse(item) })
          end
        end
      end
    end
  end
end
