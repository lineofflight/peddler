# frozen_string_literal: true

# A YARD plugin for inline RBS: yard doc --load tools/yard_rbs.rb
#
# `# @rbs name: Type -- description` becomes a @param, `# @rbs return: Type -- description` a @return, and a
# `#: (params) -> Type` line becomes a "Signature" entry and the method's return type.
require "yard"

YARD::Tags::Library.define_tag("RBS", :rbs)
YARD::Tags::Library.define_tag("Signature", :rbs_signature)
YARD::Tags::Library.visible_tags << :rbs_signature

YARD::DocstringParser.after_parse do |parser|
  tag = ->(name, text, types = nil, param = nil) { YARD::Tags::Tag.new(name, text, types, param) }
  parser.tags.select { |t| t.tag_name == "rbs" }.each do |rbs|
    parser.tags.delete(rbs)
    declaration, description = rbs.text.gsub(/\s+/, " ").split(" -- ", 2)
    name, type = declaration.split(": ", 2)
    next if type.nil? || name.start_with?("@", "(") # an instance variable, or a method type

    parser.tags << (name == "return" ? tag.call(:return, description.to_s, [type]) : tag.call(:param, description.to_s, [type], name.delete("*&")))
  end
  # "#: sig" reaches the docstring as a line that starts with a colon
  signatures, text = parser.text.lines.partition { |line| line.start_with?(": ") }
  next if signatures.empty?

  parser.text = text.join.strip
  signatures.each { |line| parser.tags << tag.call(:rbs_signature, "`#{line.delete_prefix(": ").strip}`") }
  returns = signatures.filter_map { |line| line.strip[/->\s*([^>]+)\z/, 1] }.uniq
  parser.tags << tag.call(:return, "", returns) if !returns.empty? && parser.tags.none? { |t| t.tag_name == "return" }
end
