# frozen_string_literal: true

require "peddler/types/shipping_v2/client_reference_detail"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # Object to pass additional information about the MCI Integrator shipperType: List of ClientReferenceDetail
      class ClientReferenceDetails < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ClientReferenceDetail.parse(item) }) : new
          end
        end
      end
    end
  end
end
