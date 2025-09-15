# frozen_string_literal: true

require "peddler/types/shipping_v2/active_account"

module Peddler
  module Types
    module ShippingV2
      # The Response for the GetCarrierAccountsResponse operation.
      GetCarrierAccountsResponse = Structure.new do
        # @return [Array<ActiveAccount>]
        attribute(:active_accounts, [ActiveAccount], from: "activeAccounts")
      end
    end
  end
end
