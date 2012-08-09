class AmfSocket::AmfConnection < EM::Connection
  include EM::Protocols::ObjectProtocol

  def serializer
    AmfSocket::Serializer
  end
end
