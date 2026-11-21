# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # Wrapper for a repeated image column entry in a multi-column premium image module.
      ImageColumns = Structure.new do
        attribute(:image_column, ImageColumn, null: false, from: "imageColumn")
      end
    end
  end
end
