# frozen_string_literal: true

require "helper"
require "generator/specs"

module Generator
  class SpecsTest < Minitest::Test
    def test_sync_requires_a_ref_keyword
      assert_raises(ArgumentError) { Specs.sync }
    end

    def test_pinned_sha_reads_and_strips_the_pin_file
      assert_match(/\A[0-9a-f]{40}\z/, Specs.pinned_sha)
    end

    def test_pin_file_path_is_repo_root
      assert_equal(
        File.join(Generator::Config::BASE_PATH, "selling-partner-api-models.sha"),
        Specs::PIN_FILE,
      )
    end
  end
end
