# frozen_string_literal: true

require "peddler/types/finances_v0/service_fee_event"

module Peddler
  module Types
    module FinancesV0
      # A list of information about service fee events.
      class ServiceFeeEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ServiceFeeEvent.parse(item) })
          end
        end
      end
    end
  end
end
