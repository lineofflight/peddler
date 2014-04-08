require 'helper'
require 'peddler/structured_list'

class StructuredListTest < MiniTest::Test
  def setup
    @list = Peddler::StructuredList.new('OrderStatus', 'Status')
  end

  def test_builds_a_structured_list_for_a_single_value
    exp = { 'OrderStatus.Status.1' => 'foo' }
    assert_equal exp, @list.build('foo')
  end

  def test_builds_a_structured_list_for_an_array_of_values
    exp = { 'OrderStatus.Status.1' => 'foo', 'OrderStatus.Status.2' => 'bar' }
    assert_equal exp, @list.build(%w(foo bar))
  end
end
