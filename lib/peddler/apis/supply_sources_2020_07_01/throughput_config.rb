# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The throughput configuration.
      ThroughputConfig = Structure.new do
        attribute(:throughput_unit, String, null: false, from: "throughputUnit")

        attribute?(:throughput_cap, ThroughputCap, from: "throughputCap")
      end
    end
  end
end
