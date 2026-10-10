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
# to the home page and to GitHub.
Rake::Task["doc/created.rid"].enhance do
  Dir["doc/{index,*_md}.html"].each do |page|
    html = File.read(page).gsub(/(?<=<a href=")[^"#]+/) do |path|
      path = "index.html" if path == "README_md.html"
      next path if path.include?(":") || File.exist?(File.join("doc", path))

      "https://github.com/lineofflight/peddler/blob/main/#{path.sub(/_(md|rb)\.html\z/, '.\1')}"
    end
    File.write(page, html)
  end
end
