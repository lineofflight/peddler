# frozen_string_literal: true

require "peddler/types/finances_v0/imaging_services_fee_event"

module Peddler
  module Types
    module FinancesV0
      # A list of fee events related to Amazon Imaging services.
      class ImagingServicesFeeEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ImagingServicesFeeEvent.parse(item) })
          end
        end
      end
    end
  end
end
