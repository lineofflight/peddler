# frozen_string_literal: true

# This file is generated. Do not edit.

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
