# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # All involved party identification and metadata for vendor, buyer, seller. Applicable only for direct-fulfillment
      # sellers.
      class PartyIdentificationInfoList < Array
        class << self
          def parse(array)
            new(array.map { |item| PartyIdentificationInfo.parse(item) })
          end
        end
      end
    end
  end
end
