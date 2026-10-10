# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The services capability of a supply source.
      ServicesCapability = Structure.new do
        # When true, `SupplySource` supports the Service capability.
        attribute?(:supported, :boolean, from: "isSupported")

        attribute?(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")
      end
    end
  end
end
