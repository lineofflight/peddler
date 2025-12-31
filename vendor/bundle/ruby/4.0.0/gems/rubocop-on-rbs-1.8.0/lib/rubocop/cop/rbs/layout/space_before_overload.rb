# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # @example default
        #   # bad
        #   def foo:() -> void
        #          |  () -> void
        #
        #   # good
        #   def foo: () -> void
        #          | () -> void
        class SpaceBeforeOverload < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Use one space before overload.'

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            source = processed_source.raw_source
            decl.overloads.each_with_index do |overload, i|
              loc = overload.method_type.location
              overload_char = i == 0 ? ':' : '|'

              char_start_pos = source.rindex(overload_char, loc.start_pos)
              next unless char_start_pos

              word_after_char_pos = source.index(/[^\s]/, char_start_pos + 1)
              next unless word_after_char_pos

              if char_start_pos + 2 != word_after_char_pos
                char = range_between(char_start_pos, char_start_pos + 1)
                add_offense(char) do |corrector|
                  range = range_between(char_start_pos + 1, word_after_char_pos)
                  corrector.replace(range, ' ')
                end
              end
            end
          end
        end
      end
    end
  end
end
