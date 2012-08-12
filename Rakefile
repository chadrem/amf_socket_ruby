#!/usr/bin/env rake

require 'rubygems'
require 'bundler/gem_tasks'

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
    class MyConnection < AmfSocket::AmfRpcConnection
      def post_init
        super

        puts 'Sending a request'
        send_request('hello', :foo => 'bar') do |response|
          puts "received a response to my request: #{response.result}"
        end

        puts 'Sending a message'
        send_message('hey there', ['hello', 'world'])
      end

      def receive_request(request)
        puts "received a request: #{request.command}"
        request.reply('Here is my response')
      end

      def receive_message(message)
        puts "received a message: #{message.command}"
      end
    end

    EM.start_server('localhost', 9000, MyConnection)
  end
end
