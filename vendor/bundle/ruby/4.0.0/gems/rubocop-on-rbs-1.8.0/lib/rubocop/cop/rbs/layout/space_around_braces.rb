# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks for missing spaces around braces in method definitions.
        #
        # @example
        #   # bad
        #   def bar: (){() -> void}-> void
        #
        #   # good
        #   def bar: () { () -> void } -> void
        #
        class SpaceAroundBraces < RuboCop::RBS::CopBase
          extend AutoCorrector

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            paren_level = 0
            tokens = ::RBS::Parser.lex(decl.location.source).value.reject { |t| t.type == :tTRIVIA }
            ([nil] + tokens).each_cons(3) do |before, token, after|
              case token.type
              when :pLPAREN # '('
                paren_level += 1
              when :pRPAREN # ')'
                paren_level -= 1
              when :pLBRACE # '{'
                next unless before&.type != :pQUESTION # '?'
                next unless (after.type == :pLPAREN || after.type == :pARROW)
                next unless paren_level == 0

                check_around_space(decl.location, before, token, after)
              when :pRBRACE # '}'
                next unless after.type == :pARROW
                next unless paren_level == 0

                check_around_space(decl.location, before, token, after)
              end
            end
          end

          def check_around_space(base_loc, before, token, after)
            return unless before.nil? || before.location.end_line == token.location.start_line
            return unless token.location.end_line == after.location.start_line

            if before && (before.location.end_pos + 1 != token.location.start_pos)
              brace = range_between(
                base_loc.start_pos + token.location.start_pos,
                base_loc.start_pos + token.location.end_pos,
              )
              add_offense(brace, message: "Use one space before `#{token.location.source}`.") do |corrector|
                range = range_between(
                  base_loc.start_pos + before.location.end_pos,
                  base_loc.start_pos + token.location.start_pos
                )
                corrector.replace(range, ' ')
              end
            end

            if token.location.end_pos + 1 != after.location.start_pos
              brace = range_between(
                base_loc.start_pos + token.location.start_pos,
                base_loc.start_pos + token.location.end_pos,
              )
              add_offense(brace, message: "Use one space after `#{token.location.source}`.") do |corrector|
                range = range_between(
                  base_loc.start_pos + token.location.end_pos,
                  base_loc.start_pos + after.location.start_pos
                )
                corrector.replace(range, ' ')
              end
            end
          end
        end
      end
    end
  end
end
