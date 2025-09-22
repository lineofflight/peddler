# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Contains detail codes that provide additional details related to the forward and return leg of the shipment.
      TrackingDetailCodes = Structure.new do
        # @return [Array<DetailCodes>] Contains detail codes that provide additional details related to the forward leg
        # of the shipment.
        attribute(:forward, Array)

        # @return [Array<DetailCodes>] Contains detail codes that provide additional details related to the return leg
        # of the shipment.
        attribute(:returns, Array)
      end
    end
  end
end
