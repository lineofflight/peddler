# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module MessagingV1
      # A simple object containing the name of the template.
      MessagingAction = Structure.new do
        # @return [String] The name of the template.
        attribute(:name, String)
      end
    end
  end
end
