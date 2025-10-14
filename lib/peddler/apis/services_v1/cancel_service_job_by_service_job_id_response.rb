# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Response schema for the `cancelServiceJobByServiceJobId` operation.
      CancelServiceJobByServiceJobIdResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the `cancelServiceJobByServiceJobId` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
