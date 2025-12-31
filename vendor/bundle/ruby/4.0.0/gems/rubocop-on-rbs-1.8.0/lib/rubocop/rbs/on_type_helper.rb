# frozen_string_literal: true

module RuboCop
  module RBS
    module OnTypeHelper
      def on_type(types, type, &block)
        case type
        when *types
          yield type
        end
        type.each_type do |t|
          on_type(types, t, &block)
        end
      end

      def on_not_type(types, type, &block)
        case type
        when *types
          # not
        else
          yield type
        end
        type.each_type do |t|
          on_not_type(types, t, &block)
        end
      end
    end
  end
end
