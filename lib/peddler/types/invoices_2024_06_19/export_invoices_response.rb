# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module Invoices20240619
      # Success.
      ExportInvoicesResponse = Structure.new do
        # @return [String] The export identifier.
        attribute(:export_id, String, from: "exportId")
      end
    end
  end
end
