# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks empty lines around overloads.
        #
        # @example
        #   # bad
        #   def foo: () -> void
        #
        #          | (Integer) -> Integer
        #
        #   # good
        #   def foo: () -> void
        #          | (Integer) -> Integer
        #
        class EmptyLinesAroundOverloads < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Empty line detected around overloads.'

          def on_rbs_def(decl)
            return unless 1 < decl.overloads.length

            decl.overloads.each_cons(2) do |overload, next_overload|
              check_empty_lines(overload, next_overload)
            end
          end

          def check_empty_lines(overload, next_overload)
            return if overload.method_type.location.end_line + 1 == next_overload.method_type.location.start_line

            total = 0
            range = overload.method_type.location.end_line...(next_overload.method_type.location.start_line - 1)
            processed_source.raw_source.each_line.each_with_index do |line, lineno|
              if range.cover?(lineno) && line == "\n"
                empty_line = range_between(total, total + 1)
                add_offense(empty_line) do |corrector|
                  corrector.remove(empty_line)
                end
              end
              total += line.length
            end
          end
        end
      end
    end
  end
end
