# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/supply_sources_2020_07_01/throughput_cap"

module Peddler
  module Types
    module SupplySources20200701
      # The throughput configuration.
      ThroughputConfig = Structure.new do
        # @return [String]
        attribute(:throughput_unit, String, from: "throughputUnit")

        # @return [ThroughputCap]
        attribute?(:throughput_cap, ThroughputCap, from: "throughputCap")
      end
    end
  end
end
