# frozen_string_literal: true

require 'ruby_smb'

# этот класс обеспечивает взаимодействие с smb шарами
class SmbDriver

  @address = ENV['file_server']
  @smb1 = ENV['smb1']
  @smb2 = ENV['smb2']
  @smb3 = ENV['smb3']
  @username = ENV['file_server_user']
  @password = ENV['file_server_password']
  @domain = ENV['domain']

  class << self
    def read_smb
      sock = TCPSocket.new @address, 445
      dispatcher = RubySMB::Dispatcher::Socket.new(sock)
      options = {
        smb1: false,
        smb2: true,
        smb3: false,
        username: @username,
        password: @password,
        domain: @domain
      }

      client = RubySMB::Client.new(dispatcher, **options)
      client.negotiate
      client.authenticate
    end
  end
end
