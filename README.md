# AMF Socket - Ruby

This library is an implementation of [AMF Socket](https://github.com/chadrem/amf_socket) for Ruby's EventMachine.

## Installation

Add this line to your application's Gemfile:

    gem 'amf_socket'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install amf_socket

## Usage

    EM.run do
      class MyConnection < AmfSocket::AmfRpcConnection
        private
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Chad Remesch. See LICENSE.txt for further details.
