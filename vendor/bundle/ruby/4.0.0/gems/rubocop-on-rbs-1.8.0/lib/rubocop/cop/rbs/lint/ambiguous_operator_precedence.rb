# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Checks for ambiguity of Union and Intersection operators.
        #
        # @example default
        #   # bad
        #   def foo: (A | B & C) -> void
        #
        #   # good
        #   def foo: (A | (B & C)) -> void
        #
        class AmbiguousOperatorPrecedence < RuboCop::RBS::CopBase
          MSG = 'Wrap expressions with varying precedence with parentheses to avoid ambiguity.'

          extend AutoCorrector

          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          def on_rbs_constant(const)
            check_type(const.type)
          end
          alias on_rbs_global on_rbs_constant
          alias on_rbs_type_alias on_rbs_constant
          alias on_rbs_attribute on_rbs_constant
          alias on_rbs_var on_rbs_constant

          def check_type(type)
            on_type([::RBS::Types::Union], type) do |union|
              union.types.each do |t|
                case t
                when ::RBS::Types::Intersection
                  next unless t.location

                  start_index = bsearch_token_index(t.location.start_pos)
                  end_index = bsearch_token_index(t.location.end_pos)
                  before = processed_rbs_source.tokens[start_index - 1]
                  after = processed_rbs_source.tokens[end_index]
                  unless before.type == :pLPAREN && after.type == :pRPAREN
                    range = location_to_range(t.location)
                    add_offense(range) do |corrector|
                      corrector.wrap(range, '(', ')')
                    end
                  end
                end
              end
            end
          end

          private

          def bsearch_token_index(pos)
            processed_rbs_source.tokens.bsearch_index do |token|
              token.location.start_pos >= pos
            end or raise
          end
        end
      end
    end
  end
end
