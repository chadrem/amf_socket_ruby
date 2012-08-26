require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class AmfRpcConnTestable < AmfSocket::AmfRpcConnection
  attr_accessor :sent_requests
  attr_accessor :sent_objects
  attr_accessor :received_requests
  attr_accessor :received_messages

  def self.new
    allocate.instance_eval do
      initialize
      post_init
      self
    end
  end

  def initialize
    @sent_objects = []
    @received_requests = []
    @received_messages = []
  end

  def send_object(object)
    @sent_objects << object
  end

  def receive_request(request)
    @received_requests << request
  end

  def receive_message(message)
    @received_messages << message
  end
end

describe AmfSocket::AmfRpcConnection do
  context 'when sending requests' do
    before(:each) do
      @conn = AmfRpcConnTestable.new
      @command = 'hello'
      @params = { :foo => 'bar' }
      @request = AmfSocket::RpcRequest.new(@command, @params)
      @flag = false
      @block = proc do |request|
        @flag = true
        @block_arg = request
      end

      AmfSocket::RpcRequest.should_receive(:new).with(@command, @params).and_return(@request)

      @conn.send_request(@command, @params) { |request| @block.call(request) }
    end

    it 'should send the request as a simple hash object' do
      @conn.sent_objects.first.should == @request.to_hash
    end

    it 'should execute the block and pass it a request object' do
      @flag.should == true
      @block_arg.class.should == AmfSocket::RpcRequest
    end

    it 'should register the request in order to handle the response' do
      @conn.sent_requests.first[0].should == @request.message_id
      @conn.sent_requests.first[1].should == @request
    end
  end

  context 'when sending messages' do
    before(:each) do
      @conn = AmfRpcConnTestable.new
      @command = 'hello'
      @params = { :foo => 'bar' }
      @message = AmfSocket::RpcMessage.new(@command, @params)

      AmfSocket::RpcMessage.should_receive(:new).with(@command, @params).and_return(@message)

      @conn.send_message(@command, @params)
    end

    it 'should send the message as a simple hash object' do
      @conn.sent_objects.first.should == @message.to_hash
    end
  end

  context 'when receiving objects' do
    before(:each) do
      @conn = AmfRpcConnTestable.new
    end

    it 'should handle received requests' do
      object = {
        :type => 'rpcRequest',
        :request => {
          :messageId => '123',
          :command => 'hello',
          :params => {
            :foo => 'bar'
          }
        }
      }

      @conn.receive_object(object)

      @conn.received_requests.length.should == 1

      request = @conn.received_requests.first

      request.class.should == AmfSocket::RpcReceivedRequest
      request.message_id.should == '123'
      request.command.should == 'hello'
      request.params.should == { :foo => 'bar' }
      request.connection.should == @conn
    end

    it 'should handle recevied messages' do
      object = {
        :type => 'rpcMessage',
        :message => {
          :messageId => '123',
          :command => 'hello',
          :params => {
            :foo => 'bar'
          }
        }
      }

      @conn.receive_object(object)

      @conn.received_messages.length.should == 1

      message = @conn.received_messages.first

      message.class.should == AmfSocket::RpcReceivedMessage
      message.message_id.should == '123'
      message.command.should == 'hello'
      message.params.should == { :foo => 'bar' }
      message.connection.should == @conn
    end

    it 'should handle responses for sent requests' do
      flag = false
      req = nil
      res = nil

      @conn.send_request('hello', :foo => 'bar') do |request|
        req = request

        request.succeeded do |response|
          flag = true
          res = response
        end
      end

      object = {
        :type => 'rpcResponse',
        :response => {
          :messageId => req.message_id,
          :result => 'happy ending'
        }
      }

      @conn.receive_object(object)

      flag.should == true
      res.result.should == 'happy ending'
    end
  end

  context 'when a socket gets disconnected' do
    before(:each) do
      @conn = AmfRpcConnTestable.new
    end

    it 'should trigger failure on app pending requests' do
      flag = false
      req = nil
      reas = nil

      @conn.send_request('hello', :foo => 'bar') do |request|
        req = request

        request.failed do |reason|
          flag = true
          reas = reason
        end
      end

      @conn.unbind

      flag.should == true
      reas.should == 'disconnected'
      @conn.sent_requests.length.should == 0
    end
  end
end
