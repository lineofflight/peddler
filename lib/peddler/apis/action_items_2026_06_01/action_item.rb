# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ActionItems20260601
      # A specific actionable item surfaced to a selling partner. Can be a recommendation (an opportunity to pursue), an
      # issue (a problem to fix), or a task (a mid-execution prompt requiring seller action).
      ActionItem = Structure.new do
        # Uniquely and permanently identifies the action item throughout its lifecycle.
        attribute(:action_item_id, String, null: false, from: "actionItemId")

        # A localized explanation of why Amazon is surfacing this action item.
        attribute(:description, LocalizedText, null: false)

        # When the action item was last updated. In [ISO 8601](https://developer-docs.amazon/sp-api/docs/iso-8601)
        # date-time format.
        attribute(:last_updated_date, Time, null: false, from: "lastUpdatedDate")

        # The current state of the action item. A list that combines its lifecycle state with the capabilities currently
        # available on it. For example, `AUTOMATABLE`, `DISMISSABLE`. Known values: `PENDING_SELLING_PARTNER`,
        # `AUTOMATABLE`, `DISMISSABLE`, `SNOOZABLE`, `DISMISSED`, `SNOOZED`, `OVERDUE`, `ACTIONED`, `RESOLVED`.
        attribute(:status, Array, null: false)

        # The structured classification of this action item and a reference to the definition it instantiates.
        attribute(:type, ActionItemType, null: false)

        # The date by which action must be taken. Items past this date transition to `OVERDUE` status. Absent means no
        # due date.
        attribute?(:due_date, Time, from: "dueDate")

        # The business impacts associated with this action item. Each impact is classified as a cost, benefit, or
        # enforcement and may carry quantified estimates. Only returned when `includedData` contains `impacts`.
        attribute?(:impacts, [Impact])

        # The entities this action item applies to. Only returned when `includedData` contains `references`.
        attribute?(:references, References)

        # The available ways the selling partner can act on this action item. Returned in priority order (first entry is
        # the recommended resolution). Only returned when `includedData` contains `resolutions`.
        attribute?(:resolutions, [Resolution])
      end
    end
  end
end
