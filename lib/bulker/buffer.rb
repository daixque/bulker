module Bulker
  class Buffer
    def initialize(size, &block)
      @size = size
      @buffer = []
      @on_buffered = block
    end
    
    def << (obj)
      @buffer << obj
      flush if @buffer.size == @size
    end
    
    def flush
      @on_buffered.call(@buffer)
      @buffer = []
    end
  end
end