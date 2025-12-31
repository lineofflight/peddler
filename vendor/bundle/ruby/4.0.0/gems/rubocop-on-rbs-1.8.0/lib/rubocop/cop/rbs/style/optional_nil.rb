# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # `nil?` is the same as `nil`.
        #
        # @example
        #   # bad
        #   def foo: (nil?) -> void
        #
        #   # good
        #   def foo: (nil) -> void
        #
        class OptionalNil < RuboCop::RBS::CopBase
          extend AutoCorrector

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          def check_type(type)
            find_replacement(type) do |t, replaced|
              range = location_to_range(t.location)
              add_offense(range, message: "Use `#{replaced}` instead of `#{t}`") do |corrector|
                corrector.replace(range, replaced.to_s)
              end
            end
          end

          def on_rbs_constant(const) = check_type(const.type)
          alias on_rbs_global on_rbs_constant
          alias on_rbs_type_alias on_rbs_constant
          alias on_rbs_attribute on_rbs_constant
          alias on_rbs_var on_rbs_constant

          # @rbs type: ::RBS::Types::t
          def find_replacement(type, &block)
            case type
            when ::RBS::Types::Optional
              case type.type
              when ::RBS::Types::Bases::Nil
                block.call([type, ::RBS::Types::Bases::Nil.new(location: nil)])
              else
                find_replacement(type.type, &block)
              end
            else
              type.each_type do |type|
                find_replacement(type, &block)
              end
            end
          end
        end
      end
    end
  end
end
