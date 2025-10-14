# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The Response for the GetCarrierAccountsResponse operation.
      GetCarrierAccountsResponse = Structure.new do
        # @return [Array<ActiveAccount>]
        attribute(:active_accounts, [ActiveAccount], from: "activeAccounts")
      end
    end
  end
end
