# frozen_string_literal: true

require "rdoc/task"
require_relative "../tools/rdoc_rbs"

# RDoc links a word that names a class. These name classes of Peddler, and Amazon's text and ours use them for
# what they mean: "the Feeds API", "an Error response". A qualified name still links: `Peddler::Error`.
PLAIN_WORDS = [
  "APIs", "Arguments", "Client", "Document", "Endpoint", "Error", "Feeds", "Headers", "LWA", "Marketplace", "Money",
  "Native", "Notifications", "Pagination", "Peddler", "Reports", "Response", "Status", "Tokens", "Uploads", "WebMock",
].freeze

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "doc"
  rdoc.title = "Peddler"
  rdoc.main = "README.md"
  rdoc.markup = "markdown"
  rdoc.options << "--autolink-excluded-words=#{PLAIN_WORDS.join(",")}"
  rdoc.rdoc_files.include("README.md", "UPGRADING.md", "CHANGELOG.md", "lib/peddler.rb", "lib/peddler/**/*.rb")
  rdoc.before_running_rdoc { RDocRBS.verify! }
end

# The README and the guides link to each other and to files of the repository. RDoc writes such a link as the page
# it would make of the file. The README is the home page, though, and the site holds no other file: those links go
# to the home page and to GitHub. An image of theirs is wider than a page, and Markdown gives it no width.
Rake::Task["doc/created.rid"].enhance do
  Dir["doc/{index,*_md}.html"].each do |page|
    html = File.read(page).gsub(/(?<=<a href=")[^"#]+/) do |path|
      path = "index.html" if path == "README_md.html"
      next path if path.include?(":") || File.exist?(File.join("doc", path))

      "https://github.com/lineofflight/peddler/blob/main/#{path.sub(/_(md|rb)\.html\z/, '.\1')}"
    end
    File.write(page, html.gsub("<img ", '<img style="max-width: 100%" '))
  end
end

# RDocRBS makes a list of the `@rbs` lines of a comment. RDoc calls it for every comment and promises no such call:
# were a release to stop, the site would build with the lines as they are written.
Rake::Task[:rdoc].enhance do
  raw = Dir["doc/**/*.html"].select { |page| File.read(page).include?("@rbs ") }
  next if raw.empty?

  abort("#{raw.size} pages of the site show a raw @rbs line, #{raw.first} among them: see tools/rdoc_rbs.rb.")
end
