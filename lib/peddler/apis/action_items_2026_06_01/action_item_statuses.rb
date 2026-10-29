# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ActionItems20260601
      # The state of an action item, expressed as a list combining lifecycle state with currently available
      # capabilities.
      class ActionItemStatuses < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
