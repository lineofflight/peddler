require 'helper'
require 'peddler/errors/builder'

class TestPeddlerErrorsBuilder < MiniTest::Test
  def test_builds_error_class
    Peddler::Errors::Builder.build('Foo')
    assert Peddler::Errors::Foo
  end

  def test_thread_safety
    Peddler::Errors::Builder.build('Foo')
    assert_output '', '' do
      Peddler::Errors::Builder.build('Foo')
    end
  end
end
