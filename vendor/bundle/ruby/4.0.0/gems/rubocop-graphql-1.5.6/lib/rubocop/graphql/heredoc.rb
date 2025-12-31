# frozen_string_literal: true

module RuboCop
  module GraphQL
    module Heredoc
      def heredoc?(node)
        node.type?(:str, :dstr) && node.heredoc?
      end

      def range_including_heredoc(node)
        last_heredoc = find_last_heredoc(node)

        range = node.source_range
        range = range.join(last_heredoc.loc.heredoc_end) if last_heredoc

        range_by_whole_lines(range)
      end

      private

      def find_last_heredoc(node)
        # Do a cheap check first.
        return nil unless node.source.include?("<<")

        heredocs = node.descendants.select { |descendant| heredoc?(descendant) }
        heredocs.max_by { |heredoc| heredoc.loc.heredoc_end }
      end
    end
  end
end
