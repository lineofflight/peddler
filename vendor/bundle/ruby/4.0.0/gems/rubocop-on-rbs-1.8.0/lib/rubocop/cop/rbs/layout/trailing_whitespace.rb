# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # @example default
        #   # bad
        #   class Foo[:space:]
        #     def foo: () -> void[:space:]
        #   end[:space:]
        #
        #   # good
        #   class Foo
        #     def foo: () -> void
        #   end
        class TrailingWhitespace < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = "Trailing whitespace detected."

          def on_rbs_new_investigation
            total = 0
            processed_source.raw_source.each_line do |line|
              total += line.length
              chomped = line.chomp
              next unless chomped.end_with?(' ', "\t")

              range = range_between(
                total - line.length + chomped.rstrip.length,
                total - line.length + chomped.length,
              )
              add_offense(range) do |corrector|
                corrector.remove(range)
              end
            end
          end
        end
      end
    end
  end
end
