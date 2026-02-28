# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SolicitationsV1
      # A simple object containing the name of the template.
      SolicitationsAction = Structure.new do
        # @return [String]
        attribute(:name, String, null: false)
      end
    end
  end
end
