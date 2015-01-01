require 'spec_helper'

describe AmfSocket::RpcReceivedRequest do
  before(:each) do
    @object = {
      'type' => 'rpcRequest',
      'request' => {
        'messageId' => 'random id',
        'command' => 'hello',
        'params' => {
          'foo' => 'bar'
        }
      }
    }

    @conn = stub

    @request = AmfSocket::RpcReceivedRequest.new(@object, @conn)
  end

  it 'should construct properly' do
    @request.state.should == :initialized
    @request.connection.should == @conn
    @request.message_id.should == 'random id'
    @request.command.should == 'hello'
    @request.params.should == { 'foo' => 'bar' }
  end

  it 'should reply properly' do
    @conn.should_receive(:send_object).exactly(:once)
    @request.reply('foo bar').should == true
    @request.state.should == :replied
    @request.reply('foo bar again').should == false
  end
end
