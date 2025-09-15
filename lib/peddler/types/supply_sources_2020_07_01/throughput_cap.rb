# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # The throughput capacity
      ThroughputCap = Structure.new do
        # @return [Integer]
        attribute(:value, Integer)

        # @return [String]
        attribute(:time_unit, String, from: "timeUnit")
      end
    end
  end
end
