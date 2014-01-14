require 'spec_helper'

describe Hashme::Attributes do


  before :each do
    @model = Class.new do
      include Hashme
    end
    @obj = @model.new
  end

  let :attribs do
    @obj.send(:_attributes)
  end

  describe "forwarded methods" do
    before :each do
      @hash = {:key1 => 'value1', :key2 => 'value2'}
      @obj[:key1] = 'value1'
      @obj[:key2] = 'value2'
    end

    it "should assign some of the basic hash methods" do
      (@obj == @hash).should be_true
      @obj.eql?(@hash).should be_true
      @obj.keys.should eql(@hash.keys)
      @obj.values.should eql(@hash.values)
      @obj.to_hash.should eql(@hash)
    end
  end

  describe "#[]=" do
    it "should assign values to attributes hash" do
      @obj[:akey] = "test"
      attribs[:akey].should eql("test")
      @obj['akey'] = "anothertest"
      attribs[:akey].should eql("anothertest")
      attribs['akey'].should be_nil
    end
  end

  describe "#delete" do
    it "should remove attribtue entry" do
      @obj[:key] = 'value'
      @obj.delete(:key)
      @obj[:key].should be_nil
    end
  end

  describe "#dup" do
    it "should duplicate attributes" do
      @obj[:key] = 'value'
      @obj2 = @obj.dup
      @obj2.send(:_attributes).object_id.should_not eql(@obj.send(:_attributes).object_id)
    end
  end

  describe "#clone" do
    it "should clone attributes" do
      @obj[:key] = 'value'
      @obj2 = @obj.clone
      @obj2.send(:_attributes).object_id.should_not eql(@obj.send(:_attributes).object_id)
    end
  end


  describe "#inspect" do

    it "should provide something useful" do
      @obj[:key1] = 'value1'
      @obj[:key2] = 'value2'
      @obj.inspect.should match(/#<.+ key1: "value1", key2: "value2">/)
    end

  end

end

