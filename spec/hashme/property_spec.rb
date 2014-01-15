require 'spec_helper'

describe Hashme::Property do

  let :owner do
    double()
  end

  let :klass do
    Hashme::Property
  end

  let :submodel do
    Class.new do
      include Hashme
      property :name, String
    end
  end

  describe "#initialize" do

    it "should copy name and type" do
      prop = klass.new("name", String)
      prop.name.should eql(:name)
      prop.type.should eql(String)
      prop.use_casted_array?.should be_false
    end

    it "should convert Array to CastedArray type" do
      prop = klass.new("names", [String])
      prop.name.should eql(:names)
      prop.type.should eql(String)
      prop.use_casted_array?.should be_true
    end

    it "should accept a default option" do
      prop = klass.new(:name, String, :default => "Freddo")
      prop.default.should eql("Freddo")
    end

  end

  describe "#to_s" do
    it "should use property's name" do
      prop = klass.new(:name, String)
      prop.to_s.should eql("name")
    end
  end

  describe "#to_sym" do
    it "should return the name" do
      prop = klass.new(:name, String)
      prop.to_sym.should eql (:name)
    end
  end

  describe "#cast" do
    context "without an array" do
      it "should build a new object" do
        prop = klass.new(:date, Time)
        obj = prop.cast(owner, "2013-06-02T12:00:00")
        obj.class.should eql(Time)
        obj.should eql(Time.new("2013-06-02T12:00:00"))
      end

      it "should assign casted by and property" do
        prop = klass.new(:item, submodel)
        obj = prop.cast(owner, {:name => 'test'})
        obj.casted_by.should eql(owner)
        obj.casted_by_property.should eql(prop)
      end
    end

    context "with an array" do
      it "should convert regular array to casted array" do
        prop = klass.new(:dates, [Time])
        obj = prop.cast(owner, ["2013-06-02T12:00:00"])
        obj.class.should eql(Hashme::CastedArray)
        obj.first.class.should eql(Time)
      end
      it "should handle complex objects" do
        prop = klass.new(:items, [submodel])
        obj = prop.cast(owner, [{:name => 'test'}])
        obj.class.should eql(Hashme::CastedArray)
        obj.first.class.should eql(submodel)
        obj.first.name.should eql('test')
      end
    end
  end


end
