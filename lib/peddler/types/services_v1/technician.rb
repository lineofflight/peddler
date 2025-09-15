# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ServicesV1
      # A technician who is assigned to perform the service job in part or in full.
      Technician = Structure.new do
        # @return [String] The technician identifier.
        attribute(:technician_id, String, from: "technicianId")

        # @return [String] The name of the technician.
        attribute(:name, String)
      end
    end
  end
end
