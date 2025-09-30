# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductTypeDefinitions20200901
      # The version details for an Amazon product type.
      ProductTypeVersion = Structure.new do
        # @return [String] Version identifier.
        attribute(:version, String)

        # @return [:boolean] When true, the version indicated by the version identifier is the latest available for the
        # Amazon product type.
        attribute(:latest, :boolean)

        # @return [:boolean] When true, the version indicated by the version identifier is the prerelease (release
        # candidate) for the Amazon product type.
        attribute?(:release_candidate, :boolean, from: "releaseCandidate")
      end
    end
  end
end
