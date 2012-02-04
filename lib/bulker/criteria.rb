module Bulker
  class Criteria
    class << self
      def with_array(ary)
        criteria = Criteria.new ary
        criteria.define_each lambda { |values, offset, limit, block|
          values[offset..(offset + limit - 1)].each do |v|
            block.call(v)
          end
        }
      end
    end
    
    attr_accessor :values
    
    def initialize(values)
      @values = values
      @offset = 0
      @limit = 10
    end
    
    def offset(offset)
      @offset = offset
      self
    end
    
    def limit(limit)
      @limit = limit
      self
    end
    
    def count
      @values.size
    end
    
    def define_each(each_proc)
      @each_proc = each_proc
      self
    end
    
    def each(&block)
      @each_proc.call(values, @offset, @limit, block)
    end
  end
end