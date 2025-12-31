# frozen_string_literal: true

module RuboCop
  module GraphQL
    module CompareOrder
      def correct_order?(previous, current)
        # If Order config is provided, we should use it to determine the order
        # Else, we should use alphabetical order
        # e.g. "Order" => [
        #   "id",
        #   "/^id_.*$/",
        #   "/^.*_id$/",
        #   "everything-else",
        #   "/^(created|updated)_at$/"
        # ]
        if (order = cop_config["Order"])
          # For each of previous and current, we should find the first matching order,
          # checking 'everything-else' last
          # If the order is the same, we should use alphabetical order
          # If the order is different, we should use the order
          previous_order = order_index(previous, order)
          current_order = order_index(current, order)

          if previous_order == current_order
            previous <= current
          else
            previous_order < current_order
          end
        else
          previous <= current
        end
      end

      def order_index(field, order)
        everything_else_index = order.length

        order.each_with_index do |order_item, index|
          if order_item == "everything-else"
            everything_else_index = index
          elsif order_item.start_with?("/") && order_item.end_with?("/") # is regex-like?
            return index if field.match?(order_item[1..-2])
          elsif field == order_item
            return index
          end
        end

        everything_else_index
      end
    end
  end
end
