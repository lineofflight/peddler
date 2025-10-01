# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ListingsItems20210801
      # Buyer segment or program this offer is applicable to.
      Audience = Structure.new do
        # @return [String] Localized display name for the audience.
        attribute?(:display_name, String, from: "displayName")

        # @return [String] Name of the audience an offer is applicable to.
        #
        # Common values:
        #
        # * 'ALL' - Standard offer audience for buyers on Amazon retail websites.
        #
        # * 'B2B' - Offer audience for Amazon Business website buyers.
        attribute?(:value, String)
      end
    end
  end
end
