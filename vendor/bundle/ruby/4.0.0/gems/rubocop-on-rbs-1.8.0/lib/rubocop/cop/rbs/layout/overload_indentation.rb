# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks the indentation of overloads.
        #
        # @example
        #   # bad
        #   def foo: () -> String | () -> (Integer)
        #
        #   # bad
        #   def foo: () -> String
        #       | () -> (Integer)
        #
        #   # bad
        #   def foo: () -> String |
        #            () -> (Integer)
        #
        #   # good
        #   def foo: () -> String
        #          | () -> Integer
        #
        class OverloadIndentation < RuboCop::RBS::CopBase
          extend AutoCorrector

          def on_rbs_def(decl)
            base_pos = decl.location.start_pos
            base_col = decl.location.start_column
            overload_starts = decl.overloads.map { |overload| overload.method_type.location.start_pos }
            tokens = ::RBS::Parser.lex(decl.location.source).value.reject { |t| t.type == :tTRIVIA }
            first_colon_column = base_col + tokens.find { |t| t.type == :pCOLON }&.location&.start_column
            ([nil] + tokens).each_cons(3) do |before, bar, after|
              next unless before
              next unless bar
              next unless after
              next unless bar&.type == :pBAR

              loc = bar&.location
              next unless loc
              next unless overload_starts.include?(base_pos + after.location.start_pos)

              if before.location.end_line == bar.location.start_line
                range = range_between(base_pos + bar.location.start_pos, base_pos + bar.location.end_pos)
                add_offense(range, message: "Insert newline before `|`") do |corrector|
                  space = range_between(base_pos + before.location.end_pos, base_pos + bar.location.start_pos)
                  corrector.replace(space, "\n#{' ' * first_colon_column}")
                end
              end

              if bar.location.end_line != after.location.start_line
                range = range_between(base_pos + bar.location.start_pos, base_pos + bar.location.end_pos)
                add_offense(range, message: "Remove newline after `|`") do |corrector|
                  space = range_between(base_pos + bar.location.end_pos, base_pos + after.location.start_pos)
                  corrector.replace(space, ' ')
                end
              elsif bar.location.start_column != first_colon_column
                range = range_between(base_pos + bar.location.start_pos, base_pos + bar.location.end_pos)
                add_offense(range, message: 'Indent the `|` to the first `:`') do |corrector|
                  space = range_between(base_pos + bar.location.start_pos - bar.location.start_column,
                                        base_pos + bar.location.start_pos)
                  corrector.replace(space, ' ' * first_colon_column)
                end
              end
            end
          end
        end
      end
    end
  end
end
