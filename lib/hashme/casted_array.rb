require 'forwardable'

module Hashme

  # The Hashme CastedArray is a special object wrapper that allows other Model's
  # or Objects to be stored in an array, but maintaining typecasting.
  class CastedArray
    extend Forwardable

    attr_reader :property

    def_delegators :@_array,
      :to_a, :==, :eql?, :size,
      :first, :last, :at, :length,
      :each, :reject, :empty?, :map, :collect,
      :clear, :pop, :shift, :delete, :delete_at,
      :encode_json, :as_json, :to_json,
      :inspect, :any?

    def initialize(property, values = [])
      @_array = []
      @property = property
      if values.respond_to?(:each)
        values.each do |value|
          self.push(value)
        end
      end
    end

    def <<(obj)
      @_array << instantiate_and_build(obj)
    end

    def push(obj)
      @_array.push(instantiate_and_build(obj))
    end

    def unshift(obj)
      @_array.unshift(instantiate_and_build(obj))
    end

    def [] index
      @_array[index]
    end

    def []= index, obj
      @_array[index] = instantiate_and_build(obj)
    end

    protected

    def instantiate_and_build(obj)
      property.build(obj)
    end

  end
end
