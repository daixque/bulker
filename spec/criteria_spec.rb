require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Criteria" do
  it "create array criteria with defaut offset and limit" do
    criteria = Bulker::Criteria.new (1..20).to_a
    criteria.define_each lambda { |values, offset, limit, block|
        values[offset..(offset + limit - 1)].each do |v|
          block.call(v)
        end
    }
    result = []
    criteria.each do |v|
      result << v
    end
    result.should == (1..10).to_a
  end
  
  it "create array criteria with custom offset and limit" do
    criteria = Bulker::Criteria.new (1..20).to_a
    criteria.define_each lambda { |values, offset, limit, block|
        values[offset..(offset + limit - 1)].each do |v|
          block.call(v)
        end
    }
    result = []
    criteria.offset(3).limit(4).each do |v|
      result << v
    end
    result.should == [4, 5, 6, 7]
  end
end
