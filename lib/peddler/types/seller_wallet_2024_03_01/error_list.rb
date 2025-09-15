# frozen_string_literal: true

require "peddler/types/seller_wallet_2024_03_01/error"

module Peddler
  module Types
    module SellerWallet20240301
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] List of errors
        attribute(:errors, [Error])
      end
    end
  end
end
