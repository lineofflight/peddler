# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionItems20260601
      # A localized text value paired with the locale it is rendered in.
      LocalizedText = Structure.new do
        # A BCP 47 language tag.
        attribute(:locale, String, null: false)

        # The localized text.
        attribute(:text, String, null: false)
      end
    end
  end
end
