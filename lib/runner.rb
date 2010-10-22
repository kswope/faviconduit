#!/usr/bin/env ruby

require './faviconduit'

# just a little script to run the library

# download favicons like this...
# shell> ./runner.rb slashdot.org


raise "url missing" unless uri = ARGV[0]

begin

  data = Faviconduit.read(uri)

  File.open('favicon.ico', 'w') do |file|
    file.write(data)
  end

rescue Faviconduit::MissingFavicon
  puts "favicon missing"
rescue Faviconduit::InvalidFavicon
  puts "favicon invalid"
end


