# frozen_string_literal: true

require 'helper'
require 'peddler/errors'

class TestPeddlerErrors < MiniTest::Test
  def teardown
    clients.each do |client|
      client.error_handler = proc { raise }
    end
  end

  def test_enables_new_error_handler
    clients.each do |client|
      assert_equal Peddler::Errors::Handler, client.error_handler
    end
  end

  private

  def clients
    MWS.constants.map do |klass|
      MWS.const_get(klass).const_get(:Client)
    end
  end
end
