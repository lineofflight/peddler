# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/error"

module Peddler
  module Types
    module AplusContent20201101
      # The base response data for all A+ Content operations when a request is successful or partially successful.
      # Individual operations can extend this with additional data.
      AplusResponse = Structure.new do
        # @return [Array<Error>]
        attribute(:warnings, [Error])
      end
    end
  end
end
