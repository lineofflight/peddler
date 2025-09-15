# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module SolicitationsV1
      # A simple object containing the name of the template.
      SolicitationsAction = Structure.new do
        # @return [String]
        attribute(:name, String)
      end
    end
  end
end
