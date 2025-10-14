# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Additional information related to Deferred transactions.
      DeferredContext = Structure.new do
        # @return [String] The deferral policy applied to the transaction.
        #
        # **Examples:** `B2B` (invoiced orders), `DD7` (delivery date policy)
        attribute?(:deferral_reason, String, from: "deferralReason")

        # @return [String] The release date of the transaction.
        attribute?(:maturity_date, String, from: "maturityDate")
      end
    end
  end
end
