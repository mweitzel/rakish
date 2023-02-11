require 'socket'


class Locker
  def initialize
    @lock = Thread::Mutex.new
  end

  def serve(client)
    i_own_lock = @lock.try_lock

    if i_own_lock
      client.puts response(200, "begin")
      client.recv(1000)
      ract, out = Ractor.select(
        Ractor.new(client) { |rclient|
          sleep 2
          rclient.close
          'timeout'
        },
        Ractor.new(client) { |rclient|
          begin
sleep 10
#           rclient.recv(1)
#           rclient.close
          rescue
          end
          "closed"
        }
      )
      @lock.unlock
      client.puts out
      client.close
    else
      client.puts response(400, "end")
      client.close
    end
  end

  def response(status, initial_message)
    res = <<-eos.split("\n").map(&:strip).join("\n")
      HTTP/1.0 #{status} OK

      #{initial_message}
    eos
  end
end

class Runner
  def initialize(responder)
    @responder = responder
    @server = TCPServer.new 2000 # Server bind to port 2000
  end

  def run
    loop do
      client = @server.accept    # Wait for a client to connect
      Thread.new do
        begin
          @responder.serve client
        rescue
        ensure
          #puts 'yea, closing .................'
          #client.close
        end
      end
    end
  end
end

Runner.new(Locker.new).run
