bulker
========================

*bulker* provides *Bulker::Pager* and *Bulker::Buffer*.  

 *Bulker::Pager* gives you paging functionality to split large number of data to devided segments. When 1000,000 records in your database, and you're going to do some process for each record, *Bulker::Pager* will help you. It can handle large data very easily such like array with *each* method.

*Bulker::Buffer* provides simple buffer that enables implimenting bulk insert or bulk upload behavior.

## Installation

Install bulker with RubyGems

    $ gem install bulker

or add this to your Gemfile if you use Bundler:

    $ gem "bulker"

## Usage
### Bulker::Pager

*Bulker::Pager* is especially designed for ActiveRecord. For other data source, *Bulker::Criteria* provides interface for *Bulker::Pager*.

#### Working with ActiveRecord

If you have large records in *items* table and want to process each item, then:

    require 'bulker'
    class Item < ActiveRecord::Base; end
    Bulker::Pager.each(Item.where(:status => "selling"), 100) do
      # do some process for each item
    end

This sample, *Bulker::Pager* fetches 100 items for each sql query, and continues fetching until all records are covered. Block that given to *each* method is called for each record.

#### Working with Criteria

When you use library other than ActiveRecord for accessing data soruce, you can use *Bulker::Criteria*.

    require 'bulker'
    data = (1..20).to_a
    criteria = Bulker::Criteria.new data
    criteria.define_each lambda { |values, offset, limit, block|
      values[offset..(offset + limit - 1)].each do |v|
        block.call(v)
      end
    }
    Bulker::Pager.each(criteria, 10) do |v|
      #  do some process
    end

Wrap your data objects with *Bulker::Criteria*, and define behavior of *each* method through *define_each* using lambda. Then Bulker::Pager can work with the criteria.

By default, same *each* implementation for array as above is bundled in *Bulker::Criteria* as *from_array*.

    criteria = Bulker::Criteria.from_array([1, 2, 3, 4, 5])

### Bulker::Buffer

It's easy to understand *Bulker::Buffer* behavior through seeing our RSPEC.

    require 'bulker'
    result = []
    # create buffer with size = 4
    buffer = Bulker::Buffer.new(4) do |ary|
      result << ary # when buffer filled
    end
    (1..10).each do |i|
      buffer << i
    end
    buffer.flush
    result.should == [
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 10]
    ]

## Contributing to bulker
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.


## License
bulker is released under the MIT license.

## Copyright
Copyright (c) 2012 daisuke sugimori. 

