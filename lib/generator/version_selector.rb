# frozen_string_literal: true

module Generator
  module VersionSelector
    class << self
      def find_latest_version(versions)
        versions.sort_by do |version|
          if version.start_with?("v")
            [1, version]
          else
            [2, version]
          end
        end.last
      end
    end
  end
end
