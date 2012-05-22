require 'peddler/version'

module Peddler
  # Builds a user agent that identifies the library.
  module UserAgent
    class << self
      def build
        "Peddler/#{version} (Language=#{language}; Host=#{hostname})"
      end

      private

      def engine
        defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'
      end

      def hostname
        `hostname`.chomp
      end

      def language
        [engine, RUBY_VERSION, "p#{RUBY_PATCHLEVEL}"].join ' '
      end

      def version
        Peddler::VERSION
      end
    end
  end
end
