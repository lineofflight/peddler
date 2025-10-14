# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class AplusContent20201101
      # A list of A+ Content modules.
      class ContentModuleList < Array
        class << self
          def parse(array)
            new(array.map { |item| ContentModule.parse(item) })
          end
        end
      end
    end
  end
end
