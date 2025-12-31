# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # @example
        #   # bad
        #   def foo: () { () -> bool } -> void
        #
        #   # good
        #   def foo: () { () -> boolish } -> void
        #
        class BlockReturnBoolish < RuboCop::RBS::CopBase
          extend AutoCorrector
          MSG = 'Use `boolish` instead of `bool` in block return type.'

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              next unless overload.method_type.block

              return_type = overload.method_type.block.type.return_type
              next unless return_type.is_a?(::RBS::Types::Bases::Bool)

              range = location_to_range(return_type.location)
              add_offense(range) do |corrector|
                corrector.replace(range, 'boolish')
              end
            end
          end
        end
      end
    end
  end
end
