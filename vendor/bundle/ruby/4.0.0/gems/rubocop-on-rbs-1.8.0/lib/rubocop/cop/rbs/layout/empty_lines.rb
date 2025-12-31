# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks for two or more consecutive blank lines.
        #
        # @example
        #   # bad - It has two empty lines.
        #   def foo: () -> void
        #   # one empty line
        #   # two empty lines
        #   def bar: () -> void
        #
        #   # good
        #   def foo: () -> void
        #   # one empty line
        #   def bar: () -> void
        #
        class EmptyLines < RuboCop::RBS::CopBase
          include RangeHelp
          extend AutoCorrector

          MSG = 'Extra blank line detected.'

          def on_rbs_new_investigation
            # Quick check if we possibly have consecutive blank lines.
            return unless processed_source.raw_source.include?("\n\n\n")

            source = processed_source.raw_source
            pos = 0
            while index = source.index("\n\n\n", pos)
              range = range_between(index + 2, index + 3)
              add_offense(range) do |corrector|
                corrector.remove(range)
              end
              pos = index + 1
            end
          end
        end
      end
    end
  end
end
