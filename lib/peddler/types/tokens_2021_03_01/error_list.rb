# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/tokens_2021_03_01/error"

module Peddler
  module Types
    module Tokens20210301
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
