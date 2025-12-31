# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # This cop checks the WillSyntaxError in RBS.
        # RBS with this diagnostics will fail in `rbs validate` command.
        #
        # @example
        #   # bad
        #   def foo: (void) -> void
        #
        #   # bad
        #   CONST: self
        #
        class WillSyntaxError < RuboCop::RBS::CopBase
          # @rbs!
          #    module Types = ::RBS::Types
          #    module AST = ::RBS::AST

          # @rbs skip
          AST = ::RBS::AST
          # @rbs skip
          Types = ::RBS::Types

          def on_rbs_class(decl)
            if super_class = decl.super_class
              super_class.args.each do |arg|
                void_type_context_validator(arg, true)
                no_self_type_validator(arg)
                no_classish_type_validator(arg)
              end
            end
            check_module_or_class(decl)
          end

          def on_rbs_module(decl)
            decl.self_types.each do |self_type|
              self_type.args.each do |arg|
                void_type_context_validator(arg, true)
                no_self_type_validator(arg)
                no_classish_type_validator(arg)
              end
            end
            check_module_or_class(decl)
          end

          def check_type_params(decl)
            decl.type_params.each do |param|
              if ub = param.upper_bound
                void_type_context_validator(ub)
                no_self_type_validator(ub)
                no_classish_type_validator(ub)
              end

              if param.respond_to?(:default_type)
                if dt = param.default_type
                  void_type_context_validator(dt, true)
                  no_self_type_validator(dt)
                  no_classish_type_validator(dt)
                end
              end
            end
          end

          def check_module_or_class(decl)
            check_type_params(decl)

            decl.each_member do |member|
              case member
              when AST::Members::MethodDefinition
                member.overloads.each do |ov|
                  void_type_context_validator(ov.method_type)
                end
              when AST::Members::Attribute
                void_type_context_validator(member.type)
              when AST::Members::Mixin
                member.args.each do |arg|
                  no_self_type_validator(arg)
                  unless arg.is_a?(Types::Bases::Void)
                    void_type_context_validator(arg, true)
                  end
                end
              when AST::Members::Var
                void_type_context_validator(member.type)
                if member.is_a?(AST::Members::ClassVariable)
                  no_self_type_validator(member.type)
                end
              end
            end
          end

          def on_rbs_interface(decl)
            check_type_params(decl)

            decl.members.each do |member|
              case member
              when AST::Members::MethodDefinition
                member.overloads.each do |ov|
                  void_type_context_validator(ov.method_type)
                  no_classish_type_validator(ov.method_type)
                end
              end
            end
          end

          def on_rbs_constant(decl)
            no_self_type_validator(decl.type)
            no_classish_type_validator(decl.type)
            void_type_context_validator(decl.type)
          end
          alias on_rbs_global on_rbs_constant

          def on_rbs_type_alias(decl)
            no_self_type_validator(decl.type)
            no_classish_type_validator(decl.type)
            void_type_context_validator(decl.type)

            check_type_params(decl)
          end

          private

          # @rbs type: ::RBS::Types::t
          def no_self_type_validator(type)
            case type
            when ::RBS::MethodType,
                 Types::Record,
                 Types::Tuple,
                 Types::Union,
                 Types::Intersection,
                 Types::Optional,
                 Types::ClassInstance,
                 Types::Proc
              type.each_type do |t|
                no_self_type_validator(t)
              end
            else
              if type.has_self_type?
                offence(type, "`self` type is not allowed in this context")
              end
            end
          end

          # @rbs type: ::RBS::MethodType | ::RBS::Types::t
          def no_classish_type_validator(type)
            case type
            when ::RBS::MethodType,
                 Types::Record,
                 Types::Tuple,
                 Types::Union,
                 Types::Intersection,
                 Types::Optional,
                 Types::ClassInstance,
                 Types::Proc
              type.each_type do |t|
                no_classish_type_validator(t)
              end
            when Types::Bases::Instance
              offence(type, "`instance` type is not allowed in this context")
            when Types::Bases::Class
              offence(type, "`class` type is not allowed in this context")
            else
              if type.has_classish_type?
                offence(type, "`instance` or `class` type is not allowed in this context")
              end
            end
          end

          # @rbs type: ::RBS::MethodType | ::RBS::Types::Function | ::RBS::Types::t
          # @rbs allowed_here: bool
          def void_type_context_validator(type, allowed_here = false)
            return if type.is_a?(Types::UntypedFunction)

            case type
            when ::RBS::MethodType
              void_type_context_validator(type.type)
            when Types::Function
              type.each_param do |param|
                void_type_context_validator(param.type)
              end
              case type.return_type
              when Types::Bases::Void
                # `() -> void` is allowed
              else
                void_type_context_validator(type.return_type, true)
              end
            when Types::Proc
              void_type_context_validator(type.type)
              void_type_context_validator(type.self_type) if type.self_type
              if type.block
                void_type_context_validator(type.block.type)
                void_type_context_validator(type.block.self_type) if type.block.self_type
              end
            when Types::ClassInstance
              type.args.each do |arg|
                next if arg.is_a?(Types::Bases::Void)

                void_type_context_validator(arg)
              end
            when Types::Record,
                 Types::Tuple,
                 Types::Union,
                 Types::Intersection,
                 Types::Optional
              type.each_type do |t|
                void_type_context_validator(t)
              end
            else
              if allowed_here
                return if type.is_a?(Types::Bases::Void)
              end
              if type.with_nonreturn_void?
                offence(type, "`void` type is only allowed in return type or generics parameter")
              end
            end
          end

          def offence(decl, message)
            range = location_to_range(decl.location)
            add_offense(range, message: message)
          end
        end
      end
    end
  end
end
