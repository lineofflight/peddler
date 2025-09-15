# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module MessagingV1
      # A Link object.
      LinkObject = Structure.new do
        # @return [String] A URI for this object.
        attribute(:href, String)

        # @return [String] An identifier for this object.
        attribute(:name, String)
      end
    end
  end
end
