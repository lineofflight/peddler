# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorForecasting
      # Report options specifying parameters such as sellingProgram.
      ReportOptions = Structure.new do
        # @return [String] The selling program.
        attribute(:selling_program, String, null: false, from: "sellingProgram")
      end
    end
  end
end
