#!/usr/bin/env ruby

require 'rubygems'
require 'rb-fsevent'

def sync(local, host, remote, exclude, ssh, fileName)

# Construct the bash command that runs rsync.
cmd = "rsync -rltDvzO --chmod=ugo=rwX --exclude-from " + exclude + " -e " + "\"" + ssh + "\"" + " " + "\"" + local + "\"" + " " + host + ":" + remote
# Run the command.
system cmd
# system '/usr/bin/osascript -e "display notification \"File: ' + fileName.split(//).last(30).join("").to_s + ' is synced\" with title \"Process Completed\" "'

end


local = '/Users/zhiachong/placelocal/'
host = 'zhia@dev.placelocalqa.com'
remote = '~/sandbox/'
exclude = '/Users/zhiachong/Command/exclude.txt'
ssh	= 'ssh -i /Users/zhiachong/.ssh/paperg_rsa'

fsevent = FSEvent.new
fsevent.watch local do |directories|
    directories.each do |directoryName|
        directoryInString = directoryName.to_s
        puts directoryInString
        if !((directoryInString.include? ".git") || (directoryInString.include? ".idea")) then
            sync(local, host, remote, exclude, ssh, directoryInString)
        end
    end
end

fsevent.run
