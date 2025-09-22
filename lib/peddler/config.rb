# frozen_string_literal: true

module Peddler
  module Config
    @raise_on_server_errors = false

    class << self
      attr_accessor :raise_on_server_errors
    end
  end

  class << self
    def raise_on_server_errors
      Config.raise_on_server_errors
    end

    def raise_on_server_errors=(value)
      Config.raise_on_server_errors = value
    end

    def configure
      yield Config
    end
  end
end
