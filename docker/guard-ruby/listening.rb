#!/usr/bin/env ruby

require 'listen'
require 'dir'

Dir.chdir('/app')
listener = Listen.on '0.0.0.0:4000' do |_modified, _added, _removed|
  system('rspec spec')
end
listener.start
sleep
