# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionItems20260601
      # A typed impact associated with an action item, classified as a cost, benefit, or enforcement, and optionally
      # quantified with one or more estimates.
      Impact = Structure.new do
        # One or more impact classifications (`COST`, `BENEFIT`, `ENFORCEMENT`).
        attribute(:classifications, Array, null: false)

        # Reference to the impact type definition, with a localized display name.
        attribute(:definition, ImpactDefinitionRef, null: false)

        # Optional localized description specific to this impact line.
        attribute?(:description, LocalizedText)

        # Quantified estimates for this impact.
        attribute?(:estimates, [Estimate])
      end
    end
  end
end
