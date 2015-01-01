require 'spec_helper'

describe AmfSocket::RpcResponse do
  it 'should construct properly' do
    request = stub

    response_object = {
      'type' => 'rpcResponse',
      'response' => {
        'messageId' => 'random id',
        'result' => 'foobar'
      }
    }

    response = AmfSocket::RpcResponse.new(request, response_object)

    response.request.should == request
    response.result.should == 'foobar'
  end
end
