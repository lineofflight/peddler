# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsRestrictions20210801
      # A reason for the restriction, including path forward links that may allow Selling Partners to remove the
      # restriction, if available.
      Reason = Structure.new do
        # @return [String] A message describing the reason for the restriction.
        attribute(:message, String)

        # @return [Array<Link>] A list of path forward links that may allow Selling Partners to remove the restriction.
        attribute?(:links, [Link])

        # @return [String] A code indicating why the listing is restricted.
        attribute?(:reason_code, String, from: "reasonCode")
      end
    end
  end
end
