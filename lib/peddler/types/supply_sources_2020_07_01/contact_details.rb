# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # The contact details
      ContactDetails = Structure.new do
        # @return [Hash]
        attribute(:primary, Hash)
      end
    end
  end
end
