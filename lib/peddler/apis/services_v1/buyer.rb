# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # Information about the buyer.
      Buyer = Structure.new do
        # The identifier of the buyer.
        attribute?(:buyer_id, String, from: "buyerId")

        # When true, the service is for an Amazon Prime buyer.
        attribute?(:prime_member, :boolean, from: "isPrimeMember")

        # The name of the buyer.
        attribute?(:name, String)

        # The phone number of the buyer.
        attribute?(:phone, String)
      end
    end
  end
end
