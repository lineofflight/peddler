# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # @example default
        #   # bad
        #   def foo : () -> void
        #
        #   # good
        #   def foo: () -> void
        class SpaceBeforeColon < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Avoid using spaces before `:`.'

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            source = processed_source.raw_source
            loc = decl.location
            colon_start_pos = source.index(':', loc.start_pos)
            return unless colon_start_pos

            word_before_colon_pos = source.rindex(/[^\s]/, colon_start_pos - 1)
            return unless word_before_colon_pos

            if word_before_colon_pos + 1 != colon_start_pos
              colon = range_between(colon_start_pos, colon_start_pos + 1)
              add_offense(colon) do |corrector|
                range = range_between(
                  word_before_colon_pos + 1,
                  colon_start_pos,
                )
                corrector.remove(range)
              end
            end
          end
        end
      end
    end
  end
end
