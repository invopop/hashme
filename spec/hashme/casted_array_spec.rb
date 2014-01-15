require 'spec_helper'

describe Hashme::CastedArray do

  let :owner do
    double()
  end

  let :submodel do
    Class.new do
      include Hashme
      property :name, String
    end
  end

  describe "#initialize" do
    before :each do
      @prop = Hashme::Property.new(:name, String)
      @obj = Hashme::CastedArray.new(owner, @prop, ['test'])
    end

    it "should prepare array" do
      @obj.length.should eql(1)
    end

    it "should set owner and property" do
      @obj.casted_by.should eql(owner)
      @obj.casted_by_property.should eql(@prop)
    end

    it "should instantiate and cast each value" do
      @obj.first.should eql("test")
      @obj.first.class.should eql(String)
    end
  end

  describe "adding to array" do

    before :each do
      @prop = Hashme::Property.new(:item, submodel)
      @obj = Hashme::CastedArray.new(owner, @prop, [{:name => 'test'}])
    end

    it "should cast new items" do
      @obj << {:name => 'test2'}
      @obj.last.class.should eql(submodel)
      @obj.first.name.should eql('test')
      @obj.last.name.should eql('test2')

      @obj.last.casted_by.should eql(owner)
      @obj.last.casted_by_property.should eql(@prop)
    end

  end

end
