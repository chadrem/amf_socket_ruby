require 'spec_helper'

describe AmfSocket::RpcRequest do
  it 'should construct properly' do
    SecureRandom.should_receive(:hex).and_return('random id')

    request = AmfSocket::RpcRequest.new('hello', 'foo' => 'bar')

    request.message_id.should == 'random id'
    request.command.should == 'hello'
    request.params.should == { 'foo' => 'bar' }
  end

  it 'should convert to a hash' do
    request = AmfSocket::RpcRequest.new('hello', 'foo' => 'bar')

    expected = {
      'type' => 'rpcRequest',
      'request' => {
        'messageId' => request.message_id,
        'command' => 'hello',
        'params' => {
          'foo' => 'bar'
        }
      }
    }

    request.to_hash.should == expected
  end

  it 'should store the succeeded callback' do
    request = AmfSocket::RpcRequest.new('hello', 'foo' => 'bar')

    flag = false

    request.succeeded { flag = true }
    request.succeeded_callback.call

    flag.should == true
  end

  it 'should store the failed callback' do
    request = AmfSocket::RpcRequest.new('hello', 'foo' => 'bar')

    flag = false

    request.failed { flag = true }
    request.failed_callback.call

    flag.should == true
  end

  it 'should convert to a hash' do
    message = AmfSocket::RpcRequest.new('hello', 'foo' => 'bar')

    expected = {
      'type' => 'rpcRequest',
      'request' => {
        'messageId' => message.message_id,
        'command' => 'hello',
        'params' => {
          'foo' => 'bar'
        }
      }
    }

    message.to_hash.should == expected
  end
end
