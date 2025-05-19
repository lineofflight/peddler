# frozen_string_literal: true

require "minitest/autorun"
require "generator/path"

module Generator
  class PathTest < Minitest::Test
    def test_basic_path_interpolation
      path = Path.new("/test/{paramName}", {})

      assert_equal("/test/\#{percent_encode(param_name)}", path.path)
    end

    def test_multiple_parameters
      path = Path.new("/test/{param1}/{param2}", {})

      assert_equal("/test/\#{percent_encode(param1)}/\#{percent_encode(param2)}", path.path)
    end
  end
end
