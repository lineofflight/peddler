# frozen_string_literal: true

module Generator
  module Logger
    def logger
      @logger ||= Generator.logger
    end
  end

  class << self
    def logger
      @logger ||= begin
        require "logger"
        logger = ::Logger.new($stdout)
        logger.level = ::Logger::INFO
        logger.formatter = proc do |severity, _datetime, _progname, msg|
          "[#{severity}] #{msg}\n"
        end
        logger
      end
    end
  end
end
