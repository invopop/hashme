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

  let :property do
    Hashme::Property.new(:item, submodel)
  end

  subject do
    Hashme::CastedArray.new(property, owner, [{:name => 'test'}])
  end

  describe "#initialize" do
    it "should prepare array" do
      expect(subject.length).to eql(1)
    end

    it "should set property" do
      expect(subject.property).to eql(property)
    end

    it "should instantiate and cast each value" do
      expect(subject.first.class).to eql(submodel)
      expect(subject.first.name).to eql('test')
    end
  end

  it "should cast items added to the array" do
    subject << {:name => 'test2'}
    expect(subject.last.class).to eql(submodel)
    expect(subject.last.name).to eql('test2')
  end
end
