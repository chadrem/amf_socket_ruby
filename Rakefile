#!/usr/bin/env rake

require 'rubygems'

begin
  require 'debugger'
rescue Exception
end

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts(e.message)
  $stderr.puts("Run `bundle install` to install missing gems")
  exit e.status_code
end

task :environment do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
  require 'amf_socket'
end

desc 'Start an IRB console with offier loaded'
task :console => :environment do
  require 'irb'

  ARGV.clear

  IRB.start
end

desc 'Start a test server'
task :harness => :environment do
  EM.run do
    EM.start_server('localhost', 9000, AmfSocket::AmfRpcConnection)
  end
end
