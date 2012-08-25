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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

Copyright (c) 2012 Chad Remesch. See LICENSE.txt for further details.
