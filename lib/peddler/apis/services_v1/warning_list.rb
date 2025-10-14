# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ServicesV1
      # A list of warnings returned in the sucessful execution response of an API request.
      class WarningList < Array
        class << self
          def parse(array)
            new(array.map { |item| Warning.parse(item) })
          end
        end
      end
    end
  end
end
