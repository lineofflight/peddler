# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # @example
        #   # bad
        #   def foo: () -> TrueClass
        #
        #   # bad
        #   def bar: () -> NilClass
        #
        #   # good
        #   def foo: () -> true
        #
        #   # good
        #   def bar: () -> nil
        #
        class ClassicType < RuboCop::RBS::CopBase
          extend AutoCorrector

          Types = ::RBS::Types

          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          def on_rbs_constant(decl)
            check_type(decl.type)
          end
          alias on_rbs_global on_rbs_constant
          alias on_rbs_type_alias on_rbs_constant
          alias on_rbs_attribute on_rbs_constant
          alias on_rbs_var on_rbs_constant

          # @rbs type: ::RBS::Types::t
          def check_type(type)
            find_replacement(type) do |t, replaced|
              range = location_to_range(t.location)
              add_offense(range, message: "Use `#{replaced}` instead of `#{t}`") do |corrector|
                corrector.replace(range, replaced)
              end
            end
          end

          def find_replacement(type, &block)
            case type
            when Types::Record,
                 Types::Tuple,
                 Types::Union,
                 Types::Intersection,
                 Types::Optional,
                 Types::Proc,
                 Types::Alias,
                 Types::Interface
              type.each_type do |t|
                find_replacement(t, &block)
              end
            when Types::ClassInstance
              case type.name.to_s
              when 'TrueClass', '::TrueClass'
                block.call([type, 'true'])
              when 'FalseClass', '::FalseClass'
                block.call([type, 'false'])
              when 'NilClass', '::NilClass'
                block.call([type, 'nil'])
              end
              type.each_type do |arg|
                find_replacement(arg, &block)
              end
            end
          end
        end
      end
    end
  end
end
