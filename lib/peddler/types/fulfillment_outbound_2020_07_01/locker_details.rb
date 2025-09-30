# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The locker details, which you can use to access the locker delivery box.
      LockerDetails = Structure.new do
        # @return [String] Indicates the locker number
        attribute?(:locker_number, String, from: "lockerNumber")

        # @return [String] Indicates the locker access code
        attribute?(:locker_access_code, String, from: "lockerAccessCode")
      end
    end
  end
end
