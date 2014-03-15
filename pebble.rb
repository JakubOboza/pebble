#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require 'riak'

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: pebble.rb [options]"

  opts.on("-B","--buckets", "list buckets names") do |bs|
    options[:buckets] = true
  end

  opts.on("-b","--bucket <name>", String, "list keys in bucket <name>") do |bucket_name|
    options[:bucket] = bucket_name
  end

  opts.on("-k", "--key <name>", String, "key in bucket you wanna lookup") do |key_name|
    options[:key] = key_name
  end

  opts.on("-p","--port <number>", String, "protocol buffer port") do |port|
    options[:port] = port
  end

end.parse!

params = {:protocol => "pbc"}
params.merge!(:pb_port => options[:port]) if options[:port]
client = Riak::Client.new(params)

if options[:buckets]
  client.buckets.each do |bucket|
    puts bucket.name
  end
end

if options[:bucket] && options[:key]
  puts client.bucket(options[:bucket])[options[:key]].raw_data
  exit
end

if options[:bucket]
  bucket = client.bucket(options[:bucket])
  puts bucket.keys
end

