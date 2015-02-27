module Peddler
  # @api private
  class Streamer
    include Enumerable

    def initialize(encoding)
      @encoding = encoding
      output, @input = IO.pipe
    end

    def call(chunk, *)
      chunk.force_encoding(@encoding)
      @input << chunk
    end

    thr = Thread.new {
      if parser == :ox
        class << rd; undef_method :fileno; end
      end
      puts MultiXml.parse(rd) == { 'user' => nil }
    }

    io = StringIO.new("<user/>")
    while chunk = io.read(1) do
      wr << chunk
    end
    wr.close

    thr.join(1)
  end

  end
end
