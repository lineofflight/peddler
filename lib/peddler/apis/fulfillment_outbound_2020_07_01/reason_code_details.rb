# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # A return reason code, a description, and an optional description translation.
      ReasonCodeDetails = Structure.new do
        # @return [String] A human readable description of the return reason code.
        attribute(:description, String)

        # @return [String] A code that indicates a valid return reason.
        attribute(:return_reason_code, String, from: "returnReasonCode")

        # @return [String] A translation of the description. The translation is in the language specified in the
        #   `language` request parameter.
        attribute?(:translated_description, String, from: "translatedDescription")
      end
    end
  end
end
