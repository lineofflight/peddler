# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionItems20260601
      # A reference to an impact type definition with a localized display name.
      ImpactDefinitionRef = Structure.new do
        # Machine-readable identifier of the impact type. For example, `REFERRAL_FEE`, `POTENTIAL_SALES_LIFT`.
        attribute(:impact_definition_id, String, null: false, from: "impactDefinitionId")

        # Localized display name.
        attribute?(:display_name, LocalizedText, from: "displayName")
      end
    end
  end
end
