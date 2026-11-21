# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # A request to update the configuration and capabilities of a supply source.
      UpdateSupplySourceRequest = Structure.new do
        attribute?(:alias, String)

        attribute?(:capabilities, SupplySourceCapabilities)

        attribute?(:configuration, SupplySourceConfiguration)
      end
    end
  end
end
