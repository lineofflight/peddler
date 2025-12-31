# frozen_string_literal: true

# rbs_inline: enabled

module RuboCop
  module Cop
    module RBS
      module Lint
        # Checks that there are void types in the return type of `.new` method
        # `self.new` is a special and fundamental method, and extra care should be taken regarding its return value.
        # In most cases, assigning it `void` is an unintended mistake.
        #
        # @example
        #   # bad
        #   def self.new: () -> void
        #
        #   # good
        #   def self.new: () -> instance
        #
        class NewReturnsVoid < RuboCop::RBS::CopBase
          MSG = "Don't use `void` in self.new method. Did you mean `instance`?"

          # @rbs decl: RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            return unless decl.kind == :singleton
            return unless decl.name == :new

            decl.overloads.each do |overload|
              return_type = overload.method_type.type.return_type
              case return_type
              when ::RBS::Types::Bases::Void
                next unless return_type.location

                range = location_to_range(return_type.location)
                add_offense(range)
              end
            end
          end
        end
      end
    end
  end
end
