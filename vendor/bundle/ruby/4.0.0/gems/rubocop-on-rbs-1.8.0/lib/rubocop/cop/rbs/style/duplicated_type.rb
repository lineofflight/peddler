# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # Unions and intersections of the same type are meaningless.
        #
        # @example
        #   # bad
        #   def foo: (Integer | Integer) -> void
        #
        #   # bad
        #   def foo: (Integer & Integer) -> void
        #
        #   # good
        #   def foo: (Integer) -> void
        #
        class DuplicatedType < RuboCop::RBS::CopBase
          extend AutoCorrector

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          def on_rbs_constant(decl) = check_type(decl.type)
          alias on_rbs_global on_rbs_constant
          alias on_rbs_type_alias on_rbs_constant
          alias on_rbs_attribute on_rbs_constant
          alias on_rbs_var on_rbs_constant

          # @rbs type: ::RBS::Types::t
          def check_type(type)
            case type
            when ::RBS::Types::Record,
                 ::RBS::Types::Tuple,
                 ::RBS::Types::Optional,
                 ::RBS::Types::ClassInstance,
                 ::RBS::Types::Proc
              type.each_type do |t|
                check_type(t)
              end
            when ::RBS::Types::Union,
                 ::RBS::Types::Intersection
              set = Set.new
              type.types.each do |t|
                if set.include?(t)
                  if t.location
                    range = location_to_range(t.location)
                    add_offense(range, message: "Duplicated type `#{t}`.")
                  end
                else
                  set.add(t)
                end
              end
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
