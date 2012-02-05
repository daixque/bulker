module Bulker
  # Bulker::Pager provides paging functionality to split large number of data to devided segments.
  # It can handle large data very easily such like array with each method.
  #
  # Bulker::Pager is especially designed for ActiveRecord.
  #
  #  class Item < ActiveRecord::Base; end
  #  Bulker::Pager.each(Item.where(:status => "selling"), 100) do
  #    # do some process for each item
  #  end
  #
  # For other data source, Bulker::Criteria provides interface for Bulker::Pager.
  class Pager
    class << self
      # access to every +cursor+ data with fetch limitation +limit+.
      def each(cursor, limit, &block)
        pager = Pager.new cursor, limit
        pager.each { |page| block.call(page) }
      end
    end
    
    # create pager from +cursor+ data and limitaion +limit+
    def initialize(cursor, limit)
      raise RangeError.new("limit must be positive number, but #{limit}") if limit <= 0
      @cursor = cursor
      @limit = limit
    end
    
    # access to every data.
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