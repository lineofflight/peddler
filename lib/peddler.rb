%w(feeds products reports sellers).each do |service|
  require "peddler/#{service}"
end
