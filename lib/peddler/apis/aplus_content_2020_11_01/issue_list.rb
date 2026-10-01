# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class AplusContent20201101
      # A list of issues associated with a media asset or pairing.
      class IssueList < Array
        class << self
          def parse(array)
            new(array.map { |item| Issue.parse(item) })
          end
        end
      end
    end
  end
end
