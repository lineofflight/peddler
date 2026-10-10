# frozen_string_literal: true

require "helper"
require "generator/support/config"
require "generator/support/naming"

module Generator
  class NamingTest < Minitest::Test
    def test_class_name_camelizes_with_acronyms
      assert_equal(["SKUInfo", "SellerFeedbackRating"], ["sku_info", "sellerFeedbackRating"].map { |name| Naming.class_name(name) })
    end

    # The name of a type comes from a spec, and goes into code as a constant and into the name of a file. A spec is
    # data: a name that would be anything but a constant is refused, and nothing is written.
    def test_class_name_refuses_what_is_no_constant
      names = ["String; exit 1; Evil", "Evil\nexit 1", "../../evil", "Evil.new", "evil thing", "Evil\#{exit 1}", "1st", ""]

      names.each { |name| assert_raises(ArgumentError, name.inspect) { Naming.class_name(name) } }
    end

    # The same check, for a name that is camelized already: a module named after the file of a schema.
    def test_constant_returns_a_constant_and_refuses_anything_else
      assert_equal("SalesAndTraffic20240424", Naming.constant("SalesAndTraffic20240424"))
      ["X;exit 1;y", "..", "x", "X y", "X\n", ""].each do |name|
        assert_raises(ArgumentError, name.inspect) { Naming.constant(name) }
      end
    end
  end
end
