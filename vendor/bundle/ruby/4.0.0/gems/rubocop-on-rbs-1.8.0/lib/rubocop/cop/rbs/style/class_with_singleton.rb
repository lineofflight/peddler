# rbs_inline: enabled
# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # Checks that `class` in singleton context.
        #
        # @example (default)
        #   # bad
        #   def self.foo: (class) -> class
        #
        #   # good
        #   def self.foo: (self) -> self
        #
        class ClassWithSingleton < RuboCop::RBS::CopBase
          extend AutoCorrector
          MSG = 'Use `self` instead of `class`.'

          # @rbs decl: RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            return unless decl.kind == :singleton

            decl.overloads.each do |overload|
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          # @rbs type: RBS::Types::t
          def check_type(type)
            case type
            when ::RBS::Types::Bases::Class
              return unless type.location

              range = location_to_range(type.location)
              add_offense(range) do |corrector|
                corrector.replace(range, 'self')
              end
            else
              type.each_type do |t|
                check_type(t)
              end
            end
          end
        end
      end
    end
  end
end
