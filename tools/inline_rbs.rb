# frozen_string_literal: true

# Writes sig/inline/**/*.rbs from the inline RBS annotations of the Ruby files that the Steepfile checks with
# `inline: true`. A gem ships its types in sig/ and an application's Steep reads nothing else, so this is what
# gives an application Peddler's types. It reads each file with RBS::InlineParser, the parser Steep checks with,
# so what ships is what was checked.
#
#   ruby tools/inline_rbs.rb          writes sig/inline
#   ruby tools/inline_rbs.rb --check  fails if sig/inline is not what it would write
require "pathname"
require "prism"
require "rbs"
require "steep"
require "stringio"

module InlineRBS
  ROOT = Pathname(__dir__).parent
  OUTPUT = ROOT / "sig/inline"
  VISIBILITIES = [:private, :public].freeze

  Ruby = RBS::AST::Ruby
  Declarations = RBS::AST::Declarations
  Members = RBS::AST::Members
  # The annotations of a method that may describe what they type
  DESCRIBED = [:Param, :SplatParam, :DoubleSplatParam, :BlockParam, :Return].map do |kind|
    Ruby::Annotations.const_get("#{kind}TypeAnnotation")
  end.freeze

  class << self
    # The Ruby files the Steepfile checks inline, relative to the root
    def sources
      project = Steep::Project.new(steepfile_path: ROOT / "Steepfile")
      Steep::Project::DSL.parse(project, (ROOT / "Steepfile").read)
      patterns = project.targets.map(&:inline_source_pattern)
      Dir.glob("lib/**/*.rb", base: ROOT).sort.select { |path| patterns.any? { |pattern| pattern =~ path } }
    end

    # The path of each .rbs file and its content
    def render
      sources.to_h do |path|
        [OUTPUT / path.delete_prefix("lib/").sub(/\.rb\z/, ".rbs"), rbs(path)]
      end
    end

    def rbs(path)
      source = (ROOT / path).read
      result = RBS::InlineParser.parse(RBS::Buffer.new(name: Pathname(path), content: source), Prism.parse(source))
      problems = result.diagnostics.map { |d| "#{path}:#{d.location.start_line}: #{d.message}" }
      abort(problems.join("\n")) unless problems.empty?

      out = StringIO.new
      out.puts("# Generated from #{path} by rake rbs:export. Do not edit.", "")
      RBS::Writer.new(out: out).write(result.declarations.filter_map { |decl| declaration(decl) })
      out.string
    end

    private

    def declaration(decl)
      case decl
      when Ruby::Declarations::ClassDecl
        parent = decl.super_class
        Declarations::Class.new(
          name: decl.class_name, type_params: [], members: members(decl), annotations: [], location: nil,
          comment: nil,
          super_class: parent && Declarations::Class::Super.new(name: parent.type_name, args: parent.type_args, location: nil),
        )
      when Ruby::Declarations::ModuleDecl
        Declarations::Module.new(
          name: decl.module_name, type_params: [], members: members(decl), self_types: decl.self_types,
          annotations: [], location: nil, comment: nil,
        )
      when Ruby::Declarations::ConstantDecl
        Declarations::Constant.new(
          name: decl.constant_name, type: decl.type, location: nil, comment: decl.comment, annotations: [],
        )
      when Ruby::Declarations::ClassModuleAliasDecl
        kind = decl.annotation.is_a?(Ruby::Annotations::ClassAliasAnnotation) ? Declarations::ClassAlias : Declarations::ModuleAlias
        kind.new(new_name: decl.new_name, old_name: decl.old_name, location: nil, comment: decl.comment, annotations: [])
      end
    end

    # The inline parser doesn't read visibility, so a bare `private` or `public` in the body is read here.
    def members(decl)
      statements = decl.node.body.is_a?(Prism::StatementsNode) ? decl.node.body.body : []
      switches = statements.filter_map do |node|
        next unless node.is_a?(Prism::CallNode) && node.receiver.nil? && node.arguments.nil?

        [node.location.start_line, node.name] if VISIBILITIES.include?(node.name)
      end
      visibility = :public
      decl.members.flat_map do |member|
        found = []
        while switches.first && switches.first[0] < member.location.start_line
          _, name = switches.shift
          next if name == visibility

          visibility = name
          found << (name == :private ? Members::Private : Members::Public).new(location: nil)
        end
        found.concat(Array(member(member)))
      end
    end

    def member(member)
      case member
      when Ruby::Declarations::Base then declaration(member)
      when Ruby::Members::DefMember
        Members::MethodDefinition.new(
          name: member.name, kind: member.kind, overloads: member.overloads, annotations: [], location: nil,
          comment: comment(member.leading_comment), overloading: member.overloading?, visibility: nil,
        )
      when Ruby::Members::IncludeMember then mixin(Members::Include, member)
      when Ruby::Members::ExtendMember then mixin(Members::Extend, member)
      when Ruby::Members::PrependMember then mixin(Members::Prepend, member)
      when Ruby::Members::AttributeMember
        kind = { Ruby::Members::AttrReaderMember => Members::AttrReader, Ruby::Members::AttrWriterMember => Members::AttrWriter,
                 Ruby::Members::AttrAccessorMember => Members::AttrAccessor, }.fetch(member.class)
        member.names.map do |name|
          kind.new(
            name: name, type: member.type || RBS::Types::Bases::Any.new(location: nil), ivar_name: nil, kind: :instance,
            annotations: [], location: nil, comment: member.leading_comment&.as_comment, visibility: nil,
          )
        end
      when Ruby::Members::InstanceVariableMember
        Members::InstanceVariable.new(name: member.name, type: member.type, location: nil, comment: nil)
      when Ruby::Members::ModuleSelfMember then nil
      else raise "unknown inline member: #{member.class}"
      end
    end

    # The comment above a method. The parser's own leaves the `@rbs` lines out, so what they say of a parameter or
    # of the return follows the prose as a list, and an application's hover shows it. The types stay in the
    # signature.
    def comment(block)
      return unless block

      list = block.each_paragraph([]).filter_map do |annotation|
        next unless DESCRIBED.include?(annotation.class) && annotation.comment_location

        name = annotation.is_a?(Ruby::Annotations::ReturnTypeAnnotation) ? "return" : annotation.name_location&.source
        # A description that runs on keeps the `#` of each line it takes.
        "- #{name}: #{annotation.comment_location.source.delete_prefix("--").gsub(/\s*\n\s*#\s*/, " ").strip}"
      end
      string = [block.as_comment&.string&.rstrip, list.join("\n")].compact.reject(&:empty?).join("\n\n")
      RBS::AST::Comment.new(string: string, location: nil) unless string.empty?
    end

    def mixin(kind, member)
      kind.new(name: member.module_name, args: member.type_args, annotations: [], location: nil, comment: nil)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  files = InlineRBS.render
  stale = Dir.glob("**/*.rbs", base: InlineRBS::OUTPUT).map { |path| InlineRBS::OUTPUT / path } - files.keys
  if ARGV.include?("--check")
    drift = files.reject { |path, content| path.file? && path.read == content }.keys + stale
    abort("sig/inline is out of date, run rake rbs:export:\n#{drift.join("\n")}") unless drift.empty?
    puts "sig/inline matches the inline annotations of #{files.size} files."
  else
    stale.each(&:delete)
    files.each do |path, content|
      path.dirname.mkpath
      path.write(content) unless path.file? && path.read == content
    end
    puts "Wrote #{files.size} files to sig/inline."
  end
end
