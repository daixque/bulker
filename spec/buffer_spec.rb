require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Bulker" do
  it "can buffer" do
    result = []
    buffer = Bulker::Buffer.new(4) do |ary|
      result << ary
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
  end
end
