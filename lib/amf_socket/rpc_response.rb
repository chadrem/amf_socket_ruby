class AmfSocket::RpcResponse
  attr_reader :request
  attr_reader :result

  def initialize(request, response_object)
    raise AmfSocket::InvalidObject unless validate_object(response_object)

    @result = response_object['response']['result']
    @request = request
  end

  private

  def validate_object(object)
    return false unless object.is_a?(Hash)
    return false unless object['type'] == 'rpcResponse'
    return false unless object['response'].is_a?(Hash)
    return false unless object['response']['messageId'].is_a?(String)
    return false unless object['response'].has_key?('result')

    return true
  end
end
