require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rubygems'
require 'sqlite3'
require 'active_record'
require 'logger'
require 'Fileutils'

describe "Pager" do
  DATABASE_CONFIG = {
    :adapter  => "sqlite3",
    :database => ":memory:",
    :timeout  => 5000
  }
  class TestValue < ActiveRecord::Base; end
  def insert_test_data(size)
    (1..size).each do |i|
      TestValue.create(:data => i.hash.to_s)
    end
  end
  before do
    ActiveRecord::Base.establish_connection DATABASE_CONFIG
    ActiveRecord::Base.connection.execute "
      create table if not exists test_values(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      data TEXT)"
    
    @size = 20
    insert_test_data(@size)
  end
  
  describe "Pager#each" do
    it "can paging" do
      TestValue.all.count.should == @size
      #TestValue.should_receive(:offset).exactly(4)
      pager = Bulker::Pager.new(TestValue, 5)
      result = []
      pager.each do |value|
        result << value
      end
      result.map {|v| v.id}.should == (1..@size).to_a
    end
    
    it "raise RangeError when not positive limit given" do
      lambda {
        pager = Bulker::Pager.new(TestValue, 0)
      }.should raise_error(RangeError)
    end
  end
  
  describe "Pager.each" do
    it "can paging" do
      result = []
      Bulker::Pager.each(TestValue, 3) do |value|
        result << value
      end
      result.map {|v| v.id}.should == (1..@size).to_a
    end
  end
  
  describe "Pager with Criteria" do
    it "retrieve pages from array with criteria" do
      criteria = Bulker::Criteria.from_array (1..10).to_a
      result = []
      Bulker::Pager.each(criteria, 3) do |v|
        result << v
      end
      result.should == (1..10).to_a
    end
  end
end
