module Hashme
  class Property

    attr_reader :name, :type, :array

    def initialize(name, type, opts = {})
      @name = name.to_sym

      # Always set type to base type
      if type.is_a?(Array) && !type.first.nil?
        @array = true
        @type = type.first
      else
        @array = false
        @type = type
      end

      # Handle options
      @default = opts[:default]
    end

    def to_s
      name.to_s
    end

    def to_sym
      name
    end

    def default
      return @default.call if @default.is_a?(Proc)
      @default
    end

    # Build a new object of the type defined by the property.
    def build(value)
      if array && value.is_a?(Array)
        CastedArray.new(self, value)
      else
        PropertyCasting.cast(self, value)
      end
    end

  end
end
