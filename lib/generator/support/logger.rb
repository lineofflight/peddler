# frozen_string_literal: true

require "logger"

module Generator # :nodoc:
  class << self
    def logger
      @logger ||= begin
        logger = ::Logger.new($stdout)
        logger.level = ::Logger::DEBUG

        logger
      end
    end
  end
end
