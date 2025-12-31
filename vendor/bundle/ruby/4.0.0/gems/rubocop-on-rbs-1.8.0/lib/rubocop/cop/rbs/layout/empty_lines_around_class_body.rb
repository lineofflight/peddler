# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks if empty lines around the bodies of classes match
        # the configuration.
        #
        # @example
        #   # good
        #   class Foo
        #     def bar: () -> void
        #   end
        class EmptyLinesAroundClassBody < RuboCop::RBS::CopBase
          include EmptyLinesAroundBody
          extend AutoCorrector

          KIND = 'class'

          def on_rbs_class(decl)
            check(decl)
          end
        end
      end
    end
  end
end
