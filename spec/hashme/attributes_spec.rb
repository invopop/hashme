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
      expect(@obj == @hash).to be_truthy
      expect(@obj.keys).to eql(@hash.keys)
      expect(@obj.values).to eql(@hash.values)
      expect(@obj.to_hash).to eql(@hash)
    end
  end

  describe "#[]=" do
    it "should assign values to attributes hash" do
      @obj[:akey] = "test"
      expect(attribs[:akey]).to eql("test")
      @obj['akey'] = "anothertest"
      expect(attribs[:akey]).to eql("anothertest")
      expect(attribs['akey']).to be_nil
    end
  end

  describe "#delete" do
    it "should remove attribtue entry" do
      @obj[:key] = 'value'
      @obj.delete(:key)
      expect(@obj[:key]).to be_nil
    end
  end

  describe "#dup" do
    it "should duplicate attributes" do
      @obj[:key] = 'value'
      @obj2 = @obj.dup
      expect(@obj2.send(:_attributes).object_id).to_not eql(@obj.send(:_attributes).object_id)
    end
  end

  describe "#clone" do
    it "should clone attributes" do
      @obj[:key] = 'value'
      @obj2 = @obj.clone
      expect(@obj2.send(:_attributes).object_id).to_not eql(@obj.send(:_attributes).object_id)
    end
  end


  describe "#inspect" do

    it "should provide something useful" do
      @obj[:key1] = 'value1'
      @obj[:key2] = 'value2'
      expect(@obj.inspect).to match(/#<.+ key1: "value1", key2: "value2">/)
    end

  end

end

