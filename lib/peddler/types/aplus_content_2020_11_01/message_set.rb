# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/error"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module AplusContent20201101
      # A set of messages to the user, such as warnings or comments.
      class MessageSet < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Error.parse(item) }) : new
          end
        end
      end
    end
  end
end
