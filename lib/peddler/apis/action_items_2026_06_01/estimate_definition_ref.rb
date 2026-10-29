# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # A reference to an estimate type definition with a localized display name.
      EstimateDefinitionRef = Structure.new do
        # @return [String] Machine-readable identifier of the estimate type. For example, `CATEGORY_REFERRAL_RATE`,
        #   `NINETY_DAY_SALES_LIFT`.
        attribute(:estimate_definition_id, String, null: false, from: "estimateDefinitionId")

        # @return [LocalizedText] Localized display name.
        attribute?(:display_name, LocalizedText, from: "displayName")
      end
    end
  end
end
