module Bulker
  class Criteria
    attr_accessor :values
    def initialize(values)
      @values
    end
    
    def offset(offset)
      @offset = offset
      self
    end
    
    def limit(limit)
      @limit = limit
      self
    end
    
    def define_each(&block)
      @each_proc = block.call(values, @offset, @limit)
    end
    
    def each(&block)
      @each_proc.call
    end
  end
  
  
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