# frozen_string_literal: true

require 'helper'
require 'peddler/errors/class_generator'

class TestPeddlerErrorsClassGenerator < MiniTest::Test
  def test_building_an_error_class
    Peddler::Errors::ClassGenerator.call('Foo')
    assert Peddler::Errors::Foo
  end

  def test_thread_safety
    Peddler::Errors::ClassGenerator.call('Foo')
    assert_output '', '' do
      Peddler::Errors::ClassGenerator.call('Foo')
    end
  end
end
