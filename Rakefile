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

desc 'Start an IRB console'
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

        puts 'Connected.'

        puts 'Sending a request.'
        send_request('hello', :foo => 'bar') do |request|
          request.succeeded do |response|
            puts "Request received a response. result=#{response.result}"
          end

          request.failed do |reason|
            puts "Request failed to receive a response. reason=#{reason}"
          end
        end

        puts 'Sending a message.'
        send_message('hey there', :bar => ['hello', 'world'])
      end

      def receive_request(request)
        puts "Received a request. command=#{request.command}, params=#{request.params}"
        request.reply('Here is my response')
      end

      def receive_message(message)
        puts "Received a message. command=#{message.command}, params=#{message.params}"
      end

      def unbind
        super

        puts 'Disconnected.'
      end
    end

    EM.start_server('localhost', 9000, MyConnection)
  end
end
