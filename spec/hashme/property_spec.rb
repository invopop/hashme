require 'spec_helper'

describe Hashme::Property do

  subject do
    described_class
  end

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
    it "should copy name and type" do
      prop = subject.new("name", String)
      expect(prop.name).to eql(:name)
      expect(prop.type).to eql(String)
      expect(prop.array).to be_falsey
    end

    it "should convert Array to CastedArray type" do
      prop = subject.new("names", [String])
      expect(prop.name).to eql(:names)
      expect(prop.type).to eql(String)
      expect(prop.array).to be_truthy
    end

    it "should accept a default option" do
      prop = subject.new(:name, String, :default => "Freddo")
      expect(prop.default).to eql("Freddo")
    end
  end

  describe "#to_s" do
    it "should use property's name" do
      prop = subject.new(:name, String)
      expect(prop.to_s).to eql("name")
    end
  end

  describe "#to_sym" do
    it "should return the name" do
      prop = subject.new(:name, String)
      expect(prop.to_sym).to eql (:name)
    end
  end

  describe "#build" do
    context "without an array" do
      it "should build a new object" do
        prop = subject.new(:date, Time)
        obj = prop.build(owner, "2013-06-02T12:00:00Z")
        expect(obj.class).to eql(Time)
        expect(obj).to eql(Time.utc(2013, 6, 2, 12, 0, 0))
      end

      it "should assign casted by and property" do
        prop = subject.new(:item, submodel)
        obj = prop.build(owner, {:name => 'test'})
        expect(obj.casted_by).to eql(owner)
        expect(obj.casted_by_property).to eql(prop)
      end
    end

    context "with an array" do
      it "should convert regular array to casted array" do
        prop = subject.new(:dates, [Time])
        obj = prop.build(owner, ["2013-06-02T12:00:00"])
        expect(obj.class).to eql(Hashme::CastedArray)
        expect(obj.first.class).to eql(Time)
      end
      it "should handle complex objects" do
        prop = subject.new(:items, [submodel])
        obj = prop.build(owner, [{:name => 'test'}])
        expect(obj.class).to eql(Hashme::CastedArray)
        expect(obj.first.class).to eql(submodel)
        expect(obj.first.name).to eql('test')
      end
    end
  end


end
