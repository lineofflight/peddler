# frozen_string_literal: true

require "logger"

# @!visibility private
module Generator
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
