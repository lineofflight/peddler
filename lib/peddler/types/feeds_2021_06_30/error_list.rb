# frozen_string_literal: true

require "peddler/types/feeds_2021_06_30/error"

module Peddler
  module Types
    module Feeds20210630
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] An error response returned when the request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
