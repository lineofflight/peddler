# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ListingsRestrictions20210801
      # A reason for the restriction, including path forward links that may allow Selling Partners to remove the
      # restriction, if available.
      Reason = Structure.new do
        # A message describing the reason for the restriction.
        attribute(:message, String, null: false)

        # A list of path forward links that may allow Selling Partners to remove the restriction.
        attribute?(:links, [Link])

        # A code indicating why the listing is restricted.
        attribute?(:reason_code, String, from: "reasonCode")
      end
    end
  end
end
