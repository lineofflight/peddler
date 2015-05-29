require 'helper'
require 'peddler/operation'

class TestPeddlerOperation < MiniTest::Test
  def setup
    @operation = Peddler::Operation.new('Foo')
  end

  def test_converts_key_to_structured_list
    @operation.store('FooStatus', [1, 2])
    @operation.structure!('FooStatus', 'Foo')
    refute @operation.key?('FooStatus')
    assert_equal 1, @operation['FooStatus.Foo.1']
    assert_equal 2, @operation['FooStatus.Foo.2']
  end

  def test_converts_nested_key_to_structured_list
    @operation.store('Foo.Status', [1])
    @operation.structure!('Status', 'Bar')
    refute @operation.key?('FooStatus')
    assert_equal 1, @operation['Foo.Status.Bar.1']
  end

  def test_store_camelizes_key
    @operation.store(:foo_bar, 'baz')
    assert @operation.key?('FooBar')
    refute @operation.key?(:foo_bar)
  end

  def test_store_upcases_sku
    @operation.store(:seller_sku, 'baz')
    assert @operation.key?('SellerSKU')
    refute @operation.key?(:seller_sku)
  end

  def test_store_timestamps_time_values
    ts = Minitest::Mock.new
    ts.expect(:iso8601, 'foo')
    @operation.store('time', ts)

    assert_equal 'foo', @operation.fetch('time')
  end

  def test_stringifies_hash_values
    @operation.store('Foo', bar: 1)
    assert_equal 1, @operation.fetch('Foo.Bar')
    refute @operation.key?('Foo')
  end

  def test_stringifies_nested_hash_values
    @operation.store('Foo', bar: { baz: 1 })
    assert_equal 1, @operation.fetch('Foo.Bar.Baz')
    refute @operation.key?('Foo')
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
