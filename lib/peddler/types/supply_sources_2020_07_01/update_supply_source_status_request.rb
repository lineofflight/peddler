# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # A request to update the status of a supply source.
      UpdateSupplySourceStatusRequest = Structure.new do
        # @return [String]
        attribute(:status, String)
      end
    end
  end
end
