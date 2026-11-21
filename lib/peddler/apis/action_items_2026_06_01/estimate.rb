# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionItems20260601
      # A quantified estimate for an impact. If value is present it is a single-point estimate; if minimum and maximum
      # are present it is a range.
      Estimate = Structure.new do
        # The type of estimate. Known values: `MONEY`, `PERCENT`, `COUNT`.
        attribute(:type, String, null: false)

        # ISO 4217 currency code. Present when `type` is `MONEY`.
        attribute?(:currency_code, String, from: "currencyCode")

        # Reference to the estimate's type definition, with a localized display name.
        attribute?(:definition, EstimateDefinitionRef)

        # The upper bound of a range estimate.
        attribute?(:maximum, Float)

        # The lower bound of a range estimate.
        attribute?(:minimum, Float)

        # A single-point estimate value. Present when the estimate is not a range.
        attribute?(:value, Float)
      end
    end
  end
end
