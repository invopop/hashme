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
    let :property do
      Hashme::Property.new(:name, String)
    end
    before :each do
      @obj = Hashme::CastedArray.new(property, owner, ['test'])
    end

    it "should prepare array" do
      expect(@obj.length).to eql(1)
    end

    it "should set owner and property" do
      expect(@obj.casted_by).to eql(owner)
      expect(@obj.casted_by_property).to eql(property)
    end

    it "should instantiate and cast each value" do
      expect(@obj.first).to eql("test")
      expect(@obj.first.class).to eql(String)
    end
  end

  describe "adding to array" do
    subject do
      Hashme::CastedArray.new(property, owner, [{:name => 'test'}])
    end
    let :property do
      Hashme::Property.new(:item, submodel)
    end

    it "should cast new items" do
      subject << {:name => 'test2'}
      expect(subject.last.class).to eql(submodel)
      expect(subject.first.name).to eql('test')
      expect(subject.last.name).to eql('test2')

      expect(subject.last.casted_by).to be(subject)
      expect(subject.last.casted_by_property).to eql(property)
    end

  end

end
