# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Packing slip settings.
      OrderPackingSlip = Structure.new do
        attribute?(:template_attributes, Hash, from: "templateAttributes")

        # The template name for the packing slip.
        attribute?(:template_name, String, from: "templateName")
      end
    end
  end
end
