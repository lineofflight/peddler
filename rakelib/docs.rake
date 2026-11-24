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
  rdoc.main = "RUBY.md"
  rdoc.markup = "markdown"
  rdoc.options << "--autolink-excluded-words=#{PLAIN_WORDS.join(",")}"
  rdoc.options << "--template-stylesheets=tools/rdoc_theme.css"
  rdoc.rdoc_files.include("RUBY.md", "UPGRADING.md", "CHANGELOG.md", "lib/peddler.rb", "lib/peddler/**/*.rb")
  rdoc.before_running_rdoc { RDocRBS.verify! }
end

# The guides link to each other and to files of the repository. RDoc writes such a link as the page it would make
# of the file. The Ruby guide is the home page, though, and the site holds no other file, the README included: those
# links go to the home page and to GitHub.
Rake::Task["doc/created.rid"].enhance do
  Dir["doc/{index,*_md}.html"].each do |page|
    html = File.read(page).gsub(/(?<=<a href=")[^"#]+/) do |path|
      path = "index.html" if path == "RUBY_md.html"
      next path if path.include?(":") || File.exist?(File.join("doc", path))

      "https://github.com/lineofflight/peddler/blob/main/#{path.sub(/_(md|rb)\.html\z/, '.\1')}"
    end
    File.write(page, html)
  end
end

# A typed model is a constant of its namespace and a class with a page of its own: see tools/rdoc_rbs.rb. The page
# of the namespace lists the constants, and the name of each links to the page of its model.
Rake::Task["doc/created.rid"].enhance do
  models = Dir["lib/peddler/**/*.rb"].sum { |file| File.read(file).scan(/^ *\w+ = Structure\.new do$/).size }
  linked = 0
  Dir["doc/Peddler/**/*.html"].each do |page|
    namespace = page.delete_suffix(".html")
    next unless File.directory?(namespace)

    html = File.read(page).gsub(%r{<dt id="(\w+)">\1</dt>}) do |term|
      name = Regexp.last_match(1)
      next term unless File.exist?("#{namespace}/#{name}.html")

      linked += 1
      %(<dt id="#{name}"><a href="#{File.basename(namespace)}/#{name}.html">#{name}</a></dt>)
    end
    File.write(page, html)
  end
  next if linked == models

  abort("#{models} typed models in lib, and the pages of their namespaces link #{linked}: see tools/rdoc_rbs.rb.")
end

# RDocRBS makes a list of the `@rbs` lines of a comment. RDoc calls it for every comment and promises no such call:
# were a release to stop, the site would build with the lines as they are written.
Rake::Task[:rdoc].enhance do
  raw = Dir["doc/**/*.html"].select { |page| File.read(page).include?("@rbs ") }
  next if raw.empty?

  abort("#{raw.size} pages of the site show a raw @rbs line, #{raw.first} among them: see tools/rdoc_rbs.rb.")
end

# tools/rdoc_theme.css draws the icon of the theme toggle, on the class the theme gives it.
Rake::Task[:rdoc].enhance do
  next if File.read("doc/index.html").match?(/rdoc_theme\.css.+class="theme-toggle-icon"/m)

  abort("doc/index.html shows the emoji of the theme toggle: see tools/rdoc_theme.css.")
end

# Every page of the site carries the analytics snippet, kept in tools/analytics.html. RDoc's pages leave the head
# open (HTML allows it), so the snippet goes before </head> or, failing that, before <body>, where the head ends.
Rake::Task[:rdoc].enhance do
  snippet = File.read("tools/analytics.html")
  Dir["doc/**/*.html"].each do |page|
    html = File.read(page)
    next if html.include?(snippet)

    marker = html[%r{</head>}] || html[/<body[\s>]/]
    abort("#{page} has no </head> or <body>: cannot add analytics, see tools/analytics.html.") unless marker

    File.write(page, html.sub(marker) { "#{snippet}#{marker}" })
  end
end
