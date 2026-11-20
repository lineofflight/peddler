# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionItems20260601
      # The reason a selling partner is dismissing an action item.
      DismissalReason = Structure.new do
        # One or more reasons for dismissing the action item. Known values: `NOT_APPLICABLE`, `NOT_INTERESTED`.
        attribute(:reason_types, [String], null: false, from: "reasonTypes")
      end
    end
  end
end
