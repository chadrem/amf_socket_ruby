require 'spec_helper'

describe AmfSocket::RpcReceivedMessage do
  it 'should construct properly' do
    object = {
      'type' => 'rpcMessage',
      'message' => {
        'messageId' => 'random id',
        'command' => 'hello',
        'params' => {
          'foo' => 'bar'
        }
      }
    }

    conn = stub

    message = AmfSocket::RpcReceivedMessage.new(object, conn)

    message.connection.should == conn
    message.message_id.should == 'random id'
    message.command.should == 'hello'
    message.params.should == { 'foo' => 'bar' }
  end
end
