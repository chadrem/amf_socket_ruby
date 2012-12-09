class AmfSocket::PolicyConnection < EM::Connection
  def post_init
    policy = <<-eos
      <?xml version="1.0" encoding="UTF-8"?>
      <cross-domain-policy xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.adobe.com/xml/schemas/PolicyFileSocket.xsd">
      <allow-access-from domain="*" to-ports="*"/>
      </cross-domain-policy>
    eos

    send_data(policy)
    close_connection_after_writing
  end

  def receive_data(data)
  end
end
