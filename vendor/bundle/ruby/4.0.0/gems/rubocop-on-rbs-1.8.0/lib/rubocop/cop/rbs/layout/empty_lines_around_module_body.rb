# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks if empty lines around the bodies of modules match
        # the configuration.
        #
        # @example
        #   # good
        #   module Foo
        #     def bar: () -> void
        #   end
        class EmptyLinesAroundModuleBody < RuboCop::RBS::CopBase
          include EmptyLinesAroundBody
          extend AutoCorrector

          KIND = 'module'

          def on_rbs_module(decl)
            check(decl)
          end
        end
      end
    end
  end
end
