%w(feeds products).each do |service|
  require "peddler/#{service}"
end
