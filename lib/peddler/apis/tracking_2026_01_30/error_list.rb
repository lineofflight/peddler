# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Tracking20260130
      # A list of errors for an unsuccessful request.
      ErrorList = Structure.new do
        # An array of error details.
        attribute(:errors, [Error], null: false)
      end
    end
  end
end
