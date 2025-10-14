# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
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
