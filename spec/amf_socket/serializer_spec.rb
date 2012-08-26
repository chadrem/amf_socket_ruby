require 'spec_helper'

describe AmfSocket::Serializer do
  it 'should dump an object to AMF format' do
    AmfSocket::Serializer.dump({ :foo => 'bar' }).should == "\n\v\x01\afoo\x06\abar\x01"
  end

  it 'should load an object from AMF format' do
    AmfSocket::Serializer.load("\n\v\x01\afoo\x06\abar\x01").should == { :foo => 'bar' }
  end
end
