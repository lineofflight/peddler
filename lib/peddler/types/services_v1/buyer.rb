# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Information about the buyer.
      Buyer = Structure.new do
        # @return [String] The identifier of the buyer.
        attribute(:buyer_id, String, from: "buyerId")

        # @return [String] The name of the buyer.
        attribute(:name, String)

        # @return [String] The phone number of the buyer.
        attribute(:phone, String)

        # @return [:boolean] When true, the service is for an Amazon Prime buyer.
        attribute(:prime_member, :boolean, from: "isPrimeMember")
      end
    end
  end
end
