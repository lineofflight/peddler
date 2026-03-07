# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # A list of transfer schedules.
      TransferScheduleListing = Structure.new do
        # @return [Array<TransferSchedule>] A list of transfer schedules.
        attribute(:transfer_schedules, [TransferSchedule], null: false, from: "transferSchedules")

        # @return [String] A token that you use to retrieve the next page of results. The response includes
        #   `nextPageToken` when the number of results exceeds 100. To get the next page of results, call the operation
        #   with this token and include the same arguments as the call that produced the token. To get a complete list,
        #   call this operation until `nextPageToken` is null. Note that this operation can return empty pages.
        attribute?(:next_page_token, String, from: "nextPageToken")
      end
    end
  end
end
