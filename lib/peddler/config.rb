# frozen_string_literal: true

module Peddler
  class << self
    attr_writer :raise_on_server_errors

    def raise_on_server_errors
      return @raise_on_server_errors if defined?(@raise_on_server_errors)

      @raise_on_server_errors = false # Default to v4 behavior
    end

    def configure
      yield self
    end
  end
end
