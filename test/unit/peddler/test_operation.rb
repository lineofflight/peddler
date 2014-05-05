require 'helper'
require 'peddler/operation'

class PeddlerOperationTest < MiniTest::Test
  def setup
    @operation = Peddler::Operation.new('Foo')
  end

  def test_converts_key_to_structured_list
    @operation.store('FooStatus', [1, 2])
    @operation.structure!('FooStatus', 'Foo')
    refute @operation.has_key?('FooStatus')
    assert_equal 1, @operation['FooStatus.Foo.1']
    assert_equal 2, @operation['FooStatus.Foo.2']
  end

  def test_store_camelizes_key
    @operation.store(:foo_bar, 'baz')
    assert @operation.has_key?('FooBar')
    refute @operation.has_key?(:foo_bar)
  end

  def test_store_timestamps_time_values
    ts = Minitest::Mock.new
    ts.expect(:iso8601, 'foo')
    @operation.store('time', ts)

    assert_equal 'foo', @operation.fetch('time')
  end

  def test_stringifies_hash_values
    @operation.store('Foo', { bar: 1 })
    assert_equal 1, @operation.fetch('Foo.Bar')
    refute @operation.has_key?('Foo')
  end

  def test_stringifies_nested_hash_values
    @operation.store('Foo', { bar: { baz: 1 } })
    assert_equal 1, @operation.fetch('Foo.Bar.Baz')
    refute @operation.has_key?('Foo')
  end

  def test_stringifies_struct_values
    @operation.store('Foo', Struct.new(:bar, :baz).new(1, 2))
    assert_equal 1, @operation.fetch('Foo.Bar')
    assert_equal 2, @operation.fetch('Foo.Baz')
  end

  def test_update_returns_delegator
    assert_kind_of Peddler::Operation, @operation.add(foo: 'bar')
  end
end
