# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks if empty lines around the bodies of interfaces match
        # the configuration.
        #
        # @example
        #   # good
        #   interface _Foo
        #     def bar: () -> void
        #   end
        #
        class EmptyLinesAroundInterfaceBody < RuboCop::RBS::CopBase
          include EmptyLinesAroundBody
          extend AutoCorrector

          KIND = 'interface'

          def on_rbs_interface(decl)
            check(decl)
          end
        end
      end
    end
  end
end
