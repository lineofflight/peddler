# frozen_string_literal: true

module FixtureHelpers
  def load_fixture(path)
    fixture_path = File.expand_path("../fixtures/#{path}", __dir__)
    JSON.parse(File.read(fixture_path))
  end
end
