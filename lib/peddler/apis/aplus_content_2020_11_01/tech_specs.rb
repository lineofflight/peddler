# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single technical specification.
      TechSpecs = Structure.new do
        # @return [TechSpec]
        attribute(:tech_spec, TechSpec, null: false, from: "techSpec")
      end
    end
  end
end
