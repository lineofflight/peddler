# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # The throughput capacity
      ThroughputCap = Structure.new do
        # @return [String]
        attribute?(:time_unit, String, from: "timeUnit")

        # @return [Integer]
        attribute?(:value, Integer)
      end
    end
  end
end
