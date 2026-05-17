# frozen_string_literal: true

require "helper"
require "generator"

module Generator
  class VerifyTaskTest < Minitest::Test
    EXPECTED_PATHS = [
      "lib/peddler.rb",
      "lib/peddler/apis",
      "lib/peddler/notifications",
      "lib/peddler/reports",
      "lib/peddler/feeds",
      "lib/peddler/data_kiosk",
      "sig/peddler.rbs",
      "sig/peddler/apis",
      "sig/peddler/notifications",
      "sig/peddler/reports",
      "sig/peddler/feeds",
      "sig/peddler/data_kiosk",
    ].freeze

    def test_generated_paths_match_expected
      assert_equal(EXPECTED_PATHS.sort, Generator.generated_paths.sort)
    end

    def test_generated_paths_are_tracked_by_git
      Generator.generated_paths.each do |path|
        tracked = system("git", "ls-files", "--error-unmatch", path, out: File::NULL, err: File::NULL)

        assert(tracked, "#{path} should contain committed generated code but git does not track it")
      end
    end
  end
end
