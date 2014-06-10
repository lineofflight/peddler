require 'helper'
require 'mws/order_reference_object'

class MWSOAPObjectTest < MiniTest::Test
  def test_initialization
    oro = MWS::OAPObject.new('blah')
    assert_equal oro.id, 'blah'
    assert oro.api.instance_of?(MWS::OffAmazonPayments)
  end

  def test_at_path?
    hash = MultiXml.parse('
    <foo>
      <bazes>
        <baz>
          <doge>Yummy</doge>
        </baz>
        <baz>
          <doge>Delish</doge>
        </baz>
      </bazes>
    </foo>')

    oap = MWS::OAPObject.new('whatever')

    oap.stub(:response_hash, hash) do
      assert_equal true, oap.at_path?("foo bazes baz doge", "Delish")
      assert_equal true, oap.at_path?("foo bazes baz doge", "Yummy")
      assert_equal false, oap.at_path?("foo bazes baz doge", "yummy")
      assert_equal false, oap.at_path?("foo bazes baz doge", "dumb")
    end
  end

  def test_exception_at_path?
    oap = MWS::OAPObject.new('whatever')

    hash = MultiXml.parse('<foo></foo>')
    oap.stub(:response_hash, hash) do
      assert_raises Peddler::MissingDataError do
        oap.at_path?("foo bazes baz doge", "Delish", true)
      end
    end
  end

  def test_at_path
    hash = MultiXml.parse('
    <foo>
      <simple>
        <hi>Wow</hi>
      </simple>

      <bazes>
        <baz>
          <doge>Yummy</doge>
        </baz>
        <baz>
          <doge>Delish</doge>
        </baz>
      </bazes>
    </foo>')

    oap = MWS::OAPObject.new('whatever')

    oap.stub(:response_hash, hash) do
      expected = {"baz" => [{"doge"=>"Yummy"}, {"doge"=>"Delish"}]}
      assert_equal expected, oap.at_path("foo bazes")

      assert_equal "Wow", oap.at_path("foo simple hi")
      assert_equal nil, oap.at_path("foo bazes bad path")
      assert_equal nil, oap.at_path("nothing at all")
    end
  end

  def test_exception_at_path
    hash = MultiXml.parse('
    <foo>
      <bazes>
        <baz>
          <doge>Yummy</doge>
        </baz>
        <baz>
          <doge>Delish</doge>
        </baz>
      </bazes>
    </foo>')

    oap = MWS::OAPObject.new('whatever')

    oap.stub(:response_hash, hash) do
      assert_raises Peddler::MissingDataError do
        oap.at_path("batman", true)
      end
    end
  end

  def test_splits_into_two
    oro = MWS::OrderReferenceObject.new('')

    oro.stub(:at_path, "Susie Smith", 'Some Path') do
      assert_equal ["Susie", "Smith"], oro.split_name!('Some Path')
    end
  end

  def test_errors_on_one_word_name
    oro = MWS::OrderReferenceObject.new('')

    oro.stub(:at_path, "Susie", 'Some Path') do
      assert_raises Peddler::MalformedDataError do
        oro.split_name!('Some Path')
      end
    end
  end

  def test_splits_freaky_name
    oro = MWS::OrderReferenceObject.new('')

    oro.stub(:at_path, "Xiomara Sawyer Jett Amelia", 'Some Path') do
      assert_equal ["Xiomara Sawyer Jett", "Amelia"], oro.split_name!('Some Path')
    end
  end
end
