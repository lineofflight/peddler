# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      PostContentDocumentASINRelationsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:warnings, [Error])
      end
    end
  end
end
