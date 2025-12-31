# frozen_string_literal: true

require "rubocop"

require_relative "rubocop/graphql/ext/snake_case"

require_relative "rubocop/graphql"
require_relative "rubocop/graphql/version"
require_relative "rubocop/graphql/plugin"
require_relative "rubocop/graphql/compare_order"
require_relative "rubocop/graphql/description_method"
require_relative "rubocop/graphql/heredoc"
require_relative "rubocop/graphql/node_pattern"
require_relative "rubocop/graphql/node_uniqueness"
require_relative "rubocop/graphql/sorbet"
require_relative "rubocop/graphql/swap_range"

require_relative "rubocop/graphql/argument"
require_relative "rubocop/graphql/argument/block"
require_relative "rubocop/graphql/argument/kwargs"
require_relative "rubocop/graphql/class"
require_relative "rubocop/graphql/field"
require_relative "rubocop/graphql/field/block"
require_relative "rubocop/graphql/field/kwargs"
require_relative "rubocop/graphql/schema_member"

require_relative "rubocop/cop/graphql_cops"
