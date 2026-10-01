# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper to hold the metric name and metric value.
      MetricValueItem = Structure.new do
        # @return [TextComponent]
        attribute?(:metric_name, TextComponent, from: "metricName")

        # @return [ParagraphComponent]
        attribute?(:metric_value, ParagraphComponent, from: "metricValue")
      end
    end
  end
end
