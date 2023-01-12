require 'forwardable'

module Hashme

  # The Hashme CastedArray is a special Array that typecasts each item according to a given property
  class CastedArray < Array
    attr_reader :property

    def initialize(property, vals = [])
      @property = property
      super build_all(vals)
    end

    def <<(val)
      super build(val)
    end

    def push(*vals)
      super *build_all(vals)
    end

    alias append push

    def concat(*arrays)
      super *arrays.map { |array| build_all(array) }
    end

    def insert(index, *vals)
      super index, *build_all(vals)
    end

    def unshift(*vals)
      super *build_all(vals)
    end

    alias prepend unshift

    def replace(array)
      super build_all(array)
    end

    def []=(*args)
      args = args.dup
      args[-1] = build(args[-1])
      super *args
    end

    def fill(*args, &block)
      if block
        super(*args) { |index| build(block.call(index)) }
      else
        args = args.dup
        args[0] = build(args[0])
        super(*args)
      end
    end

    def collect!(&block)
      if block
        super { |element| build(block.call(element)) }
      else
        super
      end
    end

    alias map! collect!

    protected

    def build_all(vals)
      vals.map { |val| build(val) }
    end

    def build(val)
      property.build(val)
    end
  end
end
