# rbs_inline: enabled
# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # Checks that `instance` in instance context.
        #
        # @example
        #   # bad
        #   def foo: (instance) -> instance
        #
        #   # good
        #   def foo: (self) -> self
        #
        class InstanceWithInstance < RuboCop::RBS::CopBase
          extend AutoCorrector
          MSG = 'Use `self` instead of `instance`.'

          # @rbs decl: RBS::AST::Declarations::Class
          def on_rbs_class(decl)
            # The meaning of `self` and `instance` changes in generic class.
            return unless decl.type_params.empty?

            decl.members.each do |member|
              case member
              when ::RBS::AST::Members::MethodDefinition
                next unless member.kind == :instance

                member.overloads.each do |overload|
                  overload.method_type.each_type do |type|
                    check_type(type)
                  end
                end
              when ::RBS::AST::Members::InstanceVariable
                check_type(member.type)
              end
            end
          end

          def check_type(type)
            case type
            when ::RBS::Types::Bases::Instance
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
