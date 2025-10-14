# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class AplusContent20201101
      # A set of messages to the user, such as warnings or comments.
      class MessageSet < Array
        class << self
          def parse(array)
            new(array.map { |item| Error.parse(item) })
          end
        end
      end
    end
  end
end
