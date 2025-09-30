# frozen_string_literal: true

require "set"

require "generator/logger"

module Generator
  class CircularDependencyDetector
    include Logger

    attr_reader :types

    def initialize(types)
      @types = types
    end

    def detect
      visited = Set.new
      dependency_graph.keys.each do |type_name|
        traverse_for_cycles(type_name, visited:)
      end
    end

    def circular_deps
      @circular_deps ||= Set.new
    end

    def cycle_edges
      @cycle_edges ||= Set.new
    end

    private

    def dependency_graph
      @dependency_graph ||= build_dependency_graph
    end

    def build_dependency_graph
      graph = {} #: Hash[String, Array[String]]
      types.each do |type|
        graph[type.name] = type.type_dependencies
      end
      graph
    end

    def traverse_for_cycles(node, visited: Set.new, rec_stack: [])
      return if visited.include?(node)

      visited.add(node)
      rec_stack << node

      (dependency_graph[node] || []).each do |neighbor|
        if rec_stack.include?(neighbor)
          mark_cycle(rec_stack, neighbor, node)
        elsif !visited.include?(neighbor)
          traverse_for_cycles(neighbor, visited: visited, rec_stack: rec_stack)
        end
      end

      rec_stack.pop
    end

    def mark_cycle(rec_stack, neighbor, node)
      cycle_start_index = rec_stack.index(neighbor)
      return unless cycle_start_index

      (rec_stack[cycle_start_index..-1] || []).each { |n| circular_deps.add(n) }
      edge = [node, neighbor] #: [String, String]
      logger.debug("Adding cycle edge #{edge.inspect}, rec_stack=#{rec_stack.inspect}")
      cycle_edges.add(edge)
    end
  end
end
