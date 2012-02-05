module Bulker
  # Bulker::Criteria provides interface for Bulker::Pager.
  #
  #  data = (1..20).to_a
  #  criteria = Bulker::Criteria.new data
  #  criteria.define_each lambda { |values, offset, limit, block|
  #    values[offset..(offset + limit - 1)].each do |v|
  #      block.call(v)
  #    end
  #  }
  #  Bulker::Pager.each(criteria, 10) do |v|
  #    #  do some process
  #  end
  class Criteria
    
    class << self
      # create criteria from +ary+
      def from_array(ary)
        criteria = Criteria.new ary
        criteria.define_each lambda { |values, offset, limit, block|
          values[offset..(offset + limit - 1)].each do |v|
            block.call(v)
          end
        }
      end
    end
    
    attr_accessor :values
    
    # create criteria with +values+.  
    # defaults:  
    # - +offset+ : 0
    # - +limit+ : 10
    def initialize(values)
      @values = values
      @offset = 0
      @limit = 10
    end
    
    # set +offset+ to specify offset from head of data.
    def offset(offset)
      @offset = offset
      self
    end
    
    # set +limit+ to specify numbers to fetch data.
    def limit(limit)
      @limit = limit
      self
    end
    
    # get size of +values+.
    def count
      @values.size
    end
    
    # set implementation of +each+ by lambda.
    def define_each(each_proc)
      @each_proc = each_proc
      self
    end
    
    # do +block+ for each data
    def each(&block)
      @each_proc.call(values, @offset, @limit, block)
    end
  end
end