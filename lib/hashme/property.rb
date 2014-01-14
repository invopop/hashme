module Hashme
  class Property

    attr_accessor :name, :type, :default

    def initialize(name, type, opts = {})
      self.name = name.to_sym

      # Always set type to base type
      if type.is_a?(Array) && !type.first.nil?
        @_use_casted_array = true
        klass = type.first
      else
        @_use_casted_array = false
        klass = type
      end

      self.type = klass

      # Handle options
      self.default = opts[:default]
    end

    def to_s
      name.to_s
    end

    def to_sym
      name
    end

    # Use cast method when we do not know if we may need to handle a
    # casted array of objects.
    def cast(owner, value)
      if use_casted_array?
        CastedArray.new(owner, self, value)
      else
        build(owner, value)
      end
    end

    # Build a new object of the type defined by the property.
    # Will not deal create CastedArrays!
    def build(owner, value)
      obj   = nil
      if value.is_a?(type)
        obj = value
      elsif type == Date
        obj = type.parse(value)
      else
        obj = type.new(value)
      end
      obj.casted_by = owner if obj.respond_to?(:casted_by=)
      obj.casted_by_property = self if obj.respond_to?(:casted_by_property=)
      obj
    end

    def use_casted_array?
      @_use_casted_array
    end

  end
end
