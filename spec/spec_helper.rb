$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'

require 'byebug'
require 'RocketAMF'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts(e.message)
  $stderr.puts("Run `bundle install` to install missing gems")
  exit e.status_code
end

require 'benchmark'
require 'amf_socket'

AmfSocket.enable_test_mode

AmfSocket.exception_handler do |ue|
  puts "UNHANDLED EXCEPTION #{ue.class} (#{ue.message.chomp})\n#{ue.backtrace.join("\n")}\n--"
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end
