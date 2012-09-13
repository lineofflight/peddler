%w(feeds products sellers).each do |service|
  require "peddler/#{service}"
end
