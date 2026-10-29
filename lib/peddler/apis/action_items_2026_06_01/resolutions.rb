# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ActionItems20260601
      # The available ways the selling partner can act on an action item. Returned in priority order; the first entry is
      # the recommended resolution.
      class Resolutions < Array
        class << self
          def parse(array)
            new(array.map { |item| Resolution.parse(item) })
          end
        end
      end
    end
  end
end
