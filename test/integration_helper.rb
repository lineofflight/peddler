require 'yaml'
require 'helper'

class IntegrationTest < MiniTest::Test
  class << self
    attr_accessor :api
  end

  def accounts
    YAML.load_file(File.expand_path('../fixtures/mws.yml', __FILE__))
  end

  def setup
    @clients = accounts.map { |mws| self.class.api.const_get(:Client).new(*mws.values) }
  end
end
