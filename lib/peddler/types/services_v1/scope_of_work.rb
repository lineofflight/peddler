# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # The scope of work for the order.
      ScopeOfWork = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the service job.
        attribute?(:asin, String)

        # @return [Integer] The number of service jobs.
        attribute?(:quantity, Integer)

        # @return [Array<String>] A list of skills required to perform the job.
        attribute?(:required_skills, [String], from: "requiredSkills")

        # @return [String] The title of the service job.
        attribute?(:title, String)
      end
    end
  end
end
