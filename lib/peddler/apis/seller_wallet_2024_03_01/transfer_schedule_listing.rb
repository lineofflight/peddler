# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Struct that holds collection of transfer schedules.
      TransferScheduleListing = Structure.new do
        # @return [Array<TransferSchedule>] Collection that holds list of Transfer Schedules
        attribute(:transfer_schedules, [TransferSchedule], null: false, from: "transferSchedules")

        # @return [String] If present, use this pagination token to retrieve the next page of supply sources, if not
        #   provided the API will return same response. The field will only be provided when the list is greater than
        #   100.
        attribute?(:next_page_token, String, from: "nextPageToken")
      end
    end
  end
end
