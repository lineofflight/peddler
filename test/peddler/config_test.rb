# frozen_string_literal: true

require "helper"
require "peddler/config"

module Peddler
  class ConfigTest < Minitest::Test
    def setup
      # Reset configuration to default
      Peddler.instance_variable_set(:@raise_on_server_errors, nil)
    end

    def teardown
      # Reset configuration after each test
      Peddler.instance_variable_set(:@raise_on_server_errors, nil)
    end

    def test_default_raise_on_server_errors_is_false
      refute(Peddler.raise_on_server_errors)
    end

    def test_can_set_raise_on_server_errors
      Peddler.raise_on_server_errors = true

      assert(Peddler.raise_on_server_errors)
    end

    def test_configure_block
      Peddler.configure do |config|
        config.raise_on_server_errors = true
      end

      assert(Peddler.raise_on_server_errors)
    end
  end
end
