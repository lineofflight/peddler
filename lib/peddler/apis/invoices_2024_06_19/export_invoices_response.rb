# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Success.
      ExportInvoicesResponse = Structure.new do
        # @return [String] The export identifier.
        attribute?(:export_id, String, from: "exportId")
      end
    end
  end
end
