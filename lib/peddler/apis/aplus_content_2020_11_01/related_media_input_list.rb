# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class AplusContent20201101
      # A list of related media inputs for creation.
      class RelatedMediaInputList < Array
        class << self
          def parse(array)
            new(array.map { |item| RelatedMediaInput.parse(item) })
          end
        end
      end
    end
  end
end
