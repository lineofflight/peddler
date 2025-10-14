# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A list of fee events related to Amazon Imaging services.
      class ImagingServicesFeeEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| ImagingServicesFeeEvent.parse(item) })
          end
        end
      end
    end
  end
end
