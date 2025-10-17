# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Contains detail codes that provide additional details related to the forward and return leg of the shipment.
      TrackingDetailCodes = Structure.new do
        # @return [Array<DetailCodes>] Contains detail codes that provide additional details related to the forward leg
        #   of the shipment.
        attribute(:forward, Array)

        # @return [Array<DetailCodes>] Contains detail codes that provide additional details related to the return leg
        #   of the shipment.
        attribute(:returns, Array)
      end
    end
  end
end
