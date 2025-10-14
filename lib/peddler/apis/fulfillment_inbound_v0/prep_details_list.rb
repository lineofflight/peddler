# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentInboundV0
      # A list of preparation instructions and who is responsible for that preparation.
      class PrepDetailsList < Array
        class << self
          def parse(array)
            new(array.map { |item| PrepDetails.parse(item) })
          end
        end
      end
    end
  end
end
