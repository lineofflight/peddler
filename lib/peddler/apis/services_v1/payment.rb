# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Payment information for the service job.
      Payment = Structure.new do
        # @return [MoneyAmount] The payment amount.
        attribute?(:amount, MoneyAmount)

        # @return [String] The payment instrument used for the transaction.
        attribute?(:instrument, String)
      end
    end
  end
end
