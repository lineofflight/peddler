# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # A request to update the status of a supply source.
      UpdateSupplySourceStatusRequest = Structure.new do
        # @return [String] Known values: `Active`, `Inactive`.
        attribute?(:status, String)
      end
    end
  end
end
