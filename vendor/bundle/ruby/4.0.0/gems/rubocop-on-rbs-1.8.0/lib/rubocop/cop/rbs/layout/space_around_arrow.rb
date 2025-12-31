# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks for missing spaces around the `->` operator.
        #
        # @example
        #   # bad
        #   def foo: ()->void
        #
        #   # bad
        #   def bar: () { ()->void } -> void
        #
        #   # good
        #   def foo: () -> void
        #
        #   # good
        #   def bar: () { () -> void } -> void
        #
        class SpaceAroundArrow < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG_BEFORE = 'Use one space before `->`.'
          MSG_AFTER = 'Use one space after `->`.'

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            base = decl.location.start_pos
            tokens = ::RBS::Parser.lex(decl.location.source).value.reject { |t| t.type == :tTRIVIA }
            ([nil] + tokens).each_cons(3) do |before, token, after|
              next unless token&.type == :pARROW

              loc = token&.location
              next unless loc

              if before && (before.location.end_pos + 1 != loc.start_pos)
                next unless before.location.end_line == loc.start_line

                arrow = location_to_range(loc).adjust(begin_pos: base, end_pos: base)
                add_offense(arrow, message: MSG_BEFORE) do |corrector|
                  range = range_between(before.location.end_pos, loc.start_pos)
                  corrector.replace(range.adjust(begin_pos: base, end_pos: base), ' ')
                end
              end

              if loc.end_pos + 1 != after.location.start_pos
                next unless loc.end_line == after.location.start_line

                arrow = location_to_range(loc).adjust(begin_pos: base, end_pos: base)
                add_offense(arrow, message: MSG_AFTER) do |corrector|
                  range = range_between(loc.end_pos, after.location.start_pos)
                  corrector.replace(range.adjust(begin_pos: base, end_pos: base), ' ')
                end
              end
            end
          end
          alias on_rbs_constant on_rbs_def
          alias on_rbs_global on_rbs_def
          alias on_rbs_type_alias on_rbs_def
          alias on_rbs_attribute on_rbs_def
          alias on_rbs_var on_rbs_def
        end
      end
    end
  end
end
