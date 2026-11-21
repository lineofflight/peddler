# frozen_string_literal: true

namespace :rbs do
  desc "Write sig/inline from the inline RBS annotations"
  task :export do
    ruby "tools/inline_rbs.rb"
  end

  desc "Fail if sig/inline is not what the inline annotations give"
  task :verify do
    ruby "tools/inline_rbs.rb", "--check"
  end
end
