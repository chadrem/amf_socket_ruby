require 'spec_helper'

describe AmfSocket::RpcMessage do
  it 'should construct properly' do
    SecureRandom.should_receive(:hex).and_return('random id')

    message = AmfSocket::RpcMessage.new('hello', :foo => 'bar')

    message.message_id.should == 'random id'
    message.command.should == 'hello'
    message.params.should == { :foo => 'bar' }
  end

  it 'should convert to a hash' do
    message = AmfSocket::RpcMessage.new('hello', :foo => 'bar')

    expected = {
      :type=> 'rpcMessage',
      :message => {
        :messageId => message.message_id,
        :command => 'hello',
        :params=> { :foo => 'bar'
        }
      }
    }

    message.to_hash.should == expected
  end
end
