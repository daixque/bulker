module Bulker
  class Pager
    class << self
      def each(cursor, limit, &block)
        pager = Pager.new cursor, limit
        pager.each { |page| block.call(page) }
      end
    end
    
    def initialize(cursor, limit)
      raise RangeError.new("limit must be positive number, but #{limit}") if limit <= 0
      @cursor = cursor
      @limit = limit
    end
    
    def each(&block)
      size = @cursor.count
      pages = size / @limit + (size % @limit == 0 ? 0 : 1)
      pages.times do |i|
        offset = i * @limit
        @cursor.offset(offset).limit(@limit).each do |row|
          yield row
        end
      end
    end
  end
end