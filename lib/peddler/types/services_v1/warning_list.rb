# frozen_string_literal: true

require "peddler/types/services_v1/warning"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ServicesV1
      # A list of warnings returned in the sucessful execution response of an API request.
      class WarningList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Warning.parse(item) }) : new
          end
        end
      end
    end
  end
end
