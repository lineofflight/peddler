# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionItems20260601
      # Entities referenced by an action item.
      References = Structure.new do
        # The most recent action plan associated with this action item, if any. To find every plan for an item, call
        # `listActionPlans` with `actionItemIds`.
        attribute?(:action_plans, [ActionPlanReference], from: "actionPlans")

        # Catalog references associated with the action item.
        attribute?(:catalogs, [CatalogReference])
      end
    end
  end
end
