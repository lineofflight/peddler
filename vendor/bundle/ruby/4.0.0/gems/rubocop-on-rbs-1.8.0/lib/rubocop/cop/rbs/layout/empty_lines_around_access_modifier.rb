# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Access modifiers should be surrounded by blank lines.
        #
        # @example
        #   # bad
        #   class Foo
        #     def bar: () -> void
        #     private
        #     def baz: () -> void
        #   end
        #
        #   # good
        #   class Foo
        #     def bar: () -> void
        #
        #     private
        #
        #     def baz: () -> void
        #   end
        #
        class EmptyLinesAroundAccessModifier < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Keep a blank line before and after `<%<kind>s>`.'

          def on_rbs_class(decl)
            @class_or_module_def_first_line = decl.location.start_line
            @class_or_module_def_last_line = decl.location.end_line
          end
          alias on_rbs_module on_rbs_class

          def on_rbs_public(member)
            check(member, 'public')
          end

          def on_rbs_private(member)
            check(member, 'private')
          end

          def check(member, kind)
            line = member.location.start_line

            before = processed_source.lines[line - 2]
            if before.empty? || before.match?(/[^\s]/)
              add_offense_with(member, kind)
            end

            after = processed_source.lines[line]
            if after&.empty? || after&.match?(/[^\s]/)
              add_offense_with(member, kind)
            end
          end

          def add_offense_with(member, kind)
            return if expected_empty_lines?(member)

            range = location_to_range(member.location)
            add_offense(range, message: format(MSG, kind: kind)) do |corrector|
              current_line = range_by_whole_lines(range)
              corrector.insert_before(current_line, "\n") unless previous_line_empty?(member.location.start_line)
              corrector.insert_after(current_line, "\n") unless next_line_empty?(member.location.end_line)
            end
          end

          def previous_line_ignoring_comments(processed_source, send_line)
            processed_source[0..send_line - 2].reverse.find { |line| !comment_line?(line) }
          end

          def previous_line_empty?(send_line)
            previous_line = previous_line_ignoring_comments(processed_source, send_line)
            return true unless previous_line

            class_def?(send_line) || previous_line.blank?
          end

          def next_line_empty?(last_send_line)
            next_line = processed_source[last_send_line]

            body_end?(last_send_line) || next_line.blank?
          end

          def expected_empty_lines?(member)
            previous_line_empty?(member.location.start_line) && next_line_empty?(member.location.end_line)
          end

          def class_def?(line)
            return false unless @class_or_module_def_first_line

            line == @class_or_module_def_first_line + 1
          end

          def body_end?(line)
            return false unless @class_or_module_def_last_line

            line == @class_or_module_def_last_line - 1
          end
        end
      end
    end
  end
end
