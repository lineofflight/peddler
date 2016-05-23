require 'helper'
require 'peddler/errors/builder'

class TestPeddlerErrorsBuilder < MiniTest::Test
  def test_build_error_class
    Peddler::Errors::Builder.build('Foo')
    assert Peddler::Errors::Foo
  end
end
