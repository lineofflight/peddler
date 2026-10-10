# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Support20250201
      # The content for a phone contact.
      PhoneContent = Structure.new do
        # Notes that summarize the phone call, provided by Amazon support
        attribute?(:call_notes, String, from: "callNotes")
      end
    end
  end
end
