# frozen_string_literal: true

require "helper"
require "peddler"

class PeddlerTest < Minitest::Test
  def test_entrypoint
    refute_empty(Peddler::API.constants)
  end
end
