# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionPlans20260601
      # A localized text value paired with the locale it is rendered in.
      LocalizedText = Structure.new do
        # The BCP 47 language tag, as an ISO 639 language code and ISO 3166 country code separated by a hyphen.
        attribute(:locale, String, null: false)

        # The localized text content.
        attribute(:text, String, null: false)
      end
    end
  end
end
