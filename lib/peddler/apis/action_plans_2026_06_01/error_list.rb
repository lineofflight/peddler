# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionPlans20260601
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # Error list.
        attribute(:errors, [Error], null: false)
      end
    end
  end
end
