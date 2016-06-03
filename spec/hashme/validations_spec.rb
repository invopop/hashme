require 'spec_helper'

describe Hashme::Validations do

  context "with simple validation" do
    subject do
      Class.new do
        include Hashme
        def self.name; "Example"; end
        property :name, String
        validates :name, presence: true
      end
    end

    it "should not fail when valid" do
      obj = subject.new(name: "Sam")
      expect(obj).to be_valid
      expect(obj.errors).to be_empty
    end
    it "should add error when invalid" do
      obj = subject.new
      expect(obj).to_not be_valid
      expect(obj.errors).to_not be_empty
      expect(obj.errors[:name]).to_not be_empty
    end
  end

  context "with embedded object that supports validation" do
    subject do
      submod = Class.new do
        include Hashme
        def self.name; "SubExample"; end
        property :email, String
        validates :email, presence: true
      end
      Class.new do
        include Hashme
        def self.name; "Example"; end
        property :sub, submod
      end
    end

    it "should not error when valid" do
      obj = subject.new(sub: {email: 'sam@cabify.com'})
      expect(obj).to be_valid
    end

    it "should not err if embedded object empty" do
      obj = subject.new()
      expect(obj).to be_valid
    end

    it "should provide errors when invalid" do
      obj = subject.new(sub: {})
      expect(obj).to_not be_valid
      expect(obj.errors[:sub]).to_not be_empty
      expect(obj.sub.errors).to_not be_empty
      expect(obj.sub.errors[:email]).to_not be_empty
    end

  end

end
