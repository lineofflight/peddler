# frozen_string_literal: true

require "peddler/types/listings_restrictions_2021_08_01/link"

module Peddler
  module Types
    module ListingsRestrictions20210801
      # A reason for the restriction, including path forward links that may allow Selling Partners to remove the
      # restriction, if available.
      Reason = Structure.new do
        # @return [String] A message describing the reason for the restriction.
        attribute(:message, String)

        # @return [String] A code indicating why the listing is restricted.
        attribute(:reason_code, String, from: "reasonCode")

        # @return [Array<Link>] A list of path forward links that may allow Selling Partners to remove the restriction.
        attribute(:links, [Link])
      end
    end
  end
end
