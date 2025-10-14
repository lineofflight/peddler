# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentReturns20240911
      # One-time password (OTP) details of the return item.
      OtpDetails = Structure.new do
        # @return [String] One-time password to validate the return delivered to the seller.
        attribute(:otp, String)

        # @return [Integer] The UNIX timestamp of when the verification code expires.
        attribute(:valid_till, Integer, from: "validTill")
      end
    end
  end
end
