module Hashme
  module Attributes
    include Enumerable

    extend Forwardable

    def_delegators :_attributes, :to_a,
      :==, :eql?, :keys, :values, :each,
      :reject, :reject!, :empty?, :clear, :merge, :merge!,
      :encode_json, :as_json, :to_json, :to_hash,
      :frozen?

    def []=(key, value)
      _attributes[key.to_sym] = value
    end

    def [](key)
      _attributes[key.to_sym]
    end

    def has_key?(key)
      _attributes.has_key?(key.to_sym)
    end

    def delete(key)
      _attributes.delete(key.to_sym)
    end

    def dup
      new = super
      @_attributes = @_attributes.dup
      new
    end

    def clone
      new = super
      @_attributes = @_attributes.clone
      new
    end

    def inspect
      string = keys.collect{|key|
        "#{key}: #{self[key].inspect}"
      }.compact.join(", ")
      "#<#{self.class} #{string}>"
    end

    private

    def _attributes
      @_attributes ||= {}
      @_attributes
    end

  end
end
