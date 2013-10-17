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
 

 
# FSevents wont detect changes in subdirectories that are symlinks
# (because technically the symlink has not changed)
# so list all symliks an monitor them separately
paths = []
 
# Horribly unreadable command to recursively find all symlink paths in a directory:
symlinks_cmd = "find "+ local + " -type l -exec ls -l {} \\; | grep -no '\\->.*$' | cut -c 6-"
f = open("|" + symlinks_cmd)
output = f.read()
output.each_line { |path| paths.push path.sub(/\n/, '') }

# Finally, add the root directory.
paths.push local 

puts Dir.pwd
fsevent = FSEvent.new
fsevent.watch local do |directories|
  puts "Detected change inside: #{directories.inspect}"
  sync(local, host, remote, exclude, ssh)
end

#fsevent = FSEvent.new
#fsevent.watch local do
#	puts "I observed something!"
	#sync(local, host, remote, exclude, ssh)
	#puts "Passed!"
#end
puts "Running fsevent"
fsevent.run
puts "Done running"