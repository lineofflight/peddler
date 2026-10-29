# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # A display-name declaration for a named input or output.
      InputDeclaration = Structure.new do
        # @return [LocalizedText] Localized display name for this input or output.
        attribute(:display_name, LocalizedText, null: false, from: "displayName")
      end
    end
  end
end
