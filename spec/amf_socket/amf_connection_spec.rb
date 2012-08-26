require 'spec_helper'

describe AmfSocket::AmfConnection do
  it 'should use use the amf serializer' do
    conn = AmfSocket::AmfConnection.new(nil)
    conn.serializer.should == AmfSocket::Serializer
  end
end
