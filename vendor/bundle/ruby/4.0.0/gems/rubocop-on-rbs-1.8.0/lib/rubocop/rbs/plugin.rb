# frozen_string_literal: true

require 'lint_roller'

module RuboCop
  module RBS
    # A plugin that integrates RuboCop on RBS with RuboCop's plugin system.
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: 'rubocop-on-rbs',
          version: RuboCop::RBS::VERSION,
          homepage: 'https://github.com/ksss/rubocop-on-rbs',
          description: 'A RuboCop extension focused on enforcing RBS best practices and coding conventions.'
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        project_root = Pathname.new(__dir__).join('../../..')

        LintRoller::Rules.new(type: :path, config_format: :rubocop, value: project_root.join('config', 'default.yml'))
      end
    end
  end
end
