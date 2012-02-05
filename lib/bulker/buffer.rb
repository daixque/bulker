module Bulker
  # Bulker::Buffer provides buffer pool and bulk execution functionality.
  #
  #   result = []
  #   buffer = Bulker::Buffer.new(4) do |ary|
  #     result << ary # when buffer filled
  #   end
  #   (1..10).each do |i|
  #     buffer << i
  #   end
  #   buffer.flush
  #   result #=> [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10]]
  class Buffer
    # +size+ specify size of buffer.  
    # +block+ specify callback on filled buffer.
    def initialize(size, &block)
      @size = size
      @buffer = []
      @on_buffered = block
    end
    
    # add +obj+ into buffer
    def << (obj)
      @buffer << obj
      flush if @buffer.size == @size
    end
    
    # do bulk execution and clear buffer.
    def flush
      @on_buffered.call(@buffer)
      @buffer = []
    end
  end
end