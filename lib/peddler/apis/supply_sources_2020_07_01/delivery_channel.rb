# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The delivery channel of a supply source.
      DeliveryChannel = Structure.new do
        attribute?(:supported, :boolean, from: "isSupported")

        attribute?(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")
      end
    end
  end
end
