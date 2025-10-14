# frozen_string_literal: true

require "logger"

# @!visibility private
module Generator
  class << self
    # @dynamic logger
    def logger
      @logger ||= begin
        logger = ::Logger.new($stdout)
        logger.level = ::Logger::DEBUG
        # logger.formatter = proc do |severity, _datetime, _progname, msg|
        #   "[#{severity}] #{msg}\n"
        # end
        logger
      end
    end
  end
end
