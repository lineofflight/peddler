# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      PromotionActiveTimeRange = Structure.new do
        attribute(:effective_from_date, String, null: false, from: "EffectiveFromDate")

        attribute(:effective_through_date, String, null: false, from: "EffectiveThroughDate")
      end
    end
  end
end
