# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/error"

module Peddler
  module Types
    module AplusContent20201101
      # A set of messages to the user, such as warnings or comments.
      class MessageSet < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Error.parse(item) })
          end
        end
      end
    end
  end
end
