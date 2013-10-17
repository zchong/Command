#!/usr/bin/env ruby
 
require 'rubygems'
require 'rb-fsevent'
require 'ruby-growl'
 
def sync(local, host, remote, exclude, ssh)
 
# Construct the bash command that runs rsync.
cmd = "rsync -rltDvzO --chmod=ugo=rwX --exclude-from " + exclude + " -e " + ssh + " " + local + " " + host + ":" + remote
# Run the command.
system cmd
 
end
 
 
local = '/Users/zhiachong/PaperG/placelocal/'
host = 'zhia@dev.placelocalqa.com'
remote = '~/sandbox/'
exclude = '/Users/zhiachong/Command/exclude.txt' 
ssh	= 'ssh -i /Users/zhiachong/.ssh/id_rsa'

fsevent = FSEvent.new
fsevent.watch local do |directories|
  puts "Detected change inside: #{directories.inspect}"
  sync(local, host, remote, exclude, ssh)
end

fsevent.run