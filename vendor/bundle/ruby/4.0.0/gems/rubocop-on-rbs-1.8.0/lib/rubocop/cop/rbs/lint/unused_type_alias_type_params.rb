# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Notice unused type parameters.
        #
        # @example
        #   # bad
        #   type ary[T] = Array[Integer]
        #
        #   # good
        #   type ary[T] = Array[T]
        #
        class UnusedTypeAliasTypeParams < RuboCop::RBS::CopBase
          MSG = 'Unused type variable - `%<variable>s`.'

          def on_rbs_type_alias(decl)
            return if decl.type_params.empty?

            type_params = decl.type_params.dup

            map = type_params.to_h { |param| [param.name, param] }
            type_params.each do |type_param|
              if type_param.upper_bound
                used_variable_in_type(type_param.upper_bound) do |var|
                  map.delete(var.name)
                end
              end
            end

            used_variable_in_type(decl.type) do |var|
              map.delete(var.name)
            end
            return if map.empty?

            map.each do |name, type_param|
              next unless type_param.location

              t = location_to_range(type_param.location[:name])
              add_offense(t, message: format(MSG, variable: name))
            end
          end

          def used_variable_in_type(type, &block)
            case type
            when ::RBS::Types::Variable
              yield type
            else
              type.each_type do |t|
                used_variable_in_type(t, &block)
              end
            end
          end
        end
      end
    end
  end
end
