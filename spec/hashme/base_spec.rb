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
      expect(@model).to receive(:call_in_block)
      @model.build do |model|
        @model.call_in_block
        expect(model).to be_kind_of(@model)
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
      expect(@obj.name).to eql("Sam")
    end

    it "should set default values so they are accessible by hash" do
      @model.property :surname, String, :default => "Nowl"
      @obj = @model.new
      expect(@obj.to_hash[:surname]).to eql('Nowl')
    end

  end

end

