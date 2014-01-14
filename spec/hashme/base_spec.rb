require 'spec_helper'

describe Hashme do
  
  before :each do
    @model = Class.new do
      include Hashme
      property :name, String
    end
  end
  
  describe '.build' do
    it "should create a Model and give a block to build it" do
      @model.should_receive(:call_in_block)
      @model.build do |model|
        @model.call_in_block
        model.should be_kind_of(@model)
      end
    end
  end

  describe "#initialize" do

    it "should accept nil" do
      expect {
        @obj = @model.new
      }.to_not raise_error
    end

    it "should accept and set attributes" do
      @obj = @model.new(:name => "Sam")
      @obj.name.should eql("Sam")
    end

  end

end

