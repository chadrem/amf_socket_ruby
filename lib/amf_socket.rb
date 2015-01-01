require 'eventmachine'
require 'securerandom'
require 'thread'

module AmfSocket; end

require 'amf_socket/version'
require 'amf_socket/policy_connection'
require 'amf_socket/amf_connection'
require 'amf_socket/amf_rpc_connection'
require 'amf_socket/rpc_request'
require 'amf_socket/rpc_response'
require 'amf_socket/rpc_message'
require 'amf_socket/rpc_received_request'
require 'amf_socket/rpc_received_message'
require 'amf_socket/serializer'
require 'amf_socket/exceptions'
require 'amf_socket/heartbeat'

module AmfSocket
  def self.heartbeat
    @heartbeat ||= AmfSocket::Heartbeat.new
  end

  def self.exception_handler=(handler)
    @exception_handler = handler
  end

  def self.exception_handler
    return @exception_handler
  end

  def self.try(&block)
    begin
      block.call
    rescue Exception => e
      @exception_handler.call(e) if @exception_handler
    end
  end

  def self.enable_test_mode
    @test_mode = true
  end

  def self.test_mode?
    return !!@test_mode
  end
end
