# frozen_string_literal: true

require "lint_roller"

module RuboCop
  module GraphQL
    # A plugin that integrates rubocop-graphql with RuboCop's plugin system.
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: "rubocop-graphql",
          version: VERSION,
          homepage: "https://github.com/DmitryTsepelev/rubocop-graphql",
          description: "RuboCop extension for enforcing graphql-ruby best practices."
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: Pathname.new(__dir__).join("../../../config/default.yml")
        )
      end
    end
  end
end
