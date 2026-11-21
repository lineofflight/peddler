# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MessagingV1
      # A Link object.
      LinkObject = Structure.new do
        # A URI for this object.
        attribute(:href, String, null: false)

        # An identifier for this object.
        attribute?(:name, String)
      end
    end
  end
end
