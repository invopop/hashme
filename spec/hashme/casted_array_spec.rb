require 'spec_helper'

describe Hashme::CastedArray do
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
    Hashme::CastedArray.new(property, [{:name => 'test'}])
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

  it "should cast items using `push`" do
    subject.push({ :name => 'test2'}, { :name => 'test3' })
    expect(subject.last.class).to eql(submodel)
    expect(subject.last.name).to eql('test3')
  end

  it "should cast items using `concat`" do
    subject.concat([{ :name => 'test2'}], [{ :name => 'test3' }])
    expect(subject.last.class).to eql(submodel)
    expect(subject.last.name).to eql('test3')
  end

  it "should cast items using `insert`" do
    subject.insert(0, { :name => 'test2'}, { :name => 'test3' })
    expect(subject[1].class).to eql(submodel)
    expect(subject[1].name).to eql('test3')
  end

  it "should cast items using `unshift`" do
    subject.unshift({ :name => 'test2'}, { :name => 'test3' })
    expect(subject[1].class).to eql(submodel)
    expect(subject[1].name).to eql('test3')
  end

  it "should cast items using `replace`" do
    subject.replace([{ :name => 'test2'}, { :name => 'test3' }])
    expect(subject[1].class).to eql(submodel)
    expect(subject[1].name).to eql('test3')
  end

  it "should cast items using `[]=`" do
    subject[5, 10] = { :name => 'test2'}
    expect(subject[5].class).to eql(submodel)
    expect(subject[5].name).to eql('test2')
  end

  it "should cast items using fill with block" do
    subject.fill(0) { |index| { :name => "test#{index}" } }
    expect(subject.last.class).to eql(submodel)
    expect(subject.last.name).to eql('test0')
  end

  it "should cast items using fill without block" do
    subject.fill({ :name => "test-filled" }, 0)
    expect(subject.last.class).to eql(submodel)
    expect(subject.last.name).to eql('test-filled')
  end

  it "should cast items using `collect!` with a block" do
    subject.collect! { |item| { :name => "Mapped #{item.name}" } }
    expect(subject.first.name).to eql('Mapped test')
  end

  it "should support Enumerable methods" do
    map = subject.map(&:name)
    expect(map).to be_an(Enumerable)
    expect(map.first).to eql('test')
  end

  it "should compare for equality with CastedArrays" do
    same = Hashme::CastedArray.new(property, [{:name => 'test'}])
    different = Hashme::CastedArray.new(property, [{:name => 'test2'}])

    expect(subject == same).to be(true)
    expect(subject.eql?(same)).to be(true)

    expect(subject == different).to be(false)
    expect(subject.eql?(different)).to be(false)
  end

  it "should compare for equality with Arrays" do
    same = [submodel.new(:name => 'test')]
    different = [submodel.new(:name => 'test2')]

    expect(subject == same).to be(true)
    expect(subject.eql?(same)).to be(true)

    expect(subject == different).to be(false)
    expect(subject.eql?(different)).to be(false)
  end

  it "should be compared for equality with Arrays" do
    same = [submodel.new(:name => 'test')]
    different = [submodel.new(:name => 'test2')]

    expect(same == subject).to be(true)
    expect(same.eql?(subject)).to be(true)

    expect(different == same).to be(false)
    expect(different.eql?(same)).to be(false)
  end
end
