module Hashme
  module Properties
    extend ActiveSupport::Concern

    included do
      class_attribute :properties
      self.properties = {}
    end

    def get_attribute(name)
      self[name]
    end

    def set_attribute(name, value)
      property = get_property(name)
      if property.nil?
        self[name.to_sym] = value
      else
        self[property.name] = property.build(self, value)
      end
    end

    protected

    # Go through each property and make sure it has a default value.
    def set_defaults
      (self.class.properties || {}).each do |key, property|
        unless property.default.nil?
          self[property.name] = property.default
        end
      end
    end

    # Internal method to go through each attribute and set the
    # values via the set_attribute method.
    def set_attributes(attrs = {})
      attrs.each do |key, value|
        set_attribute(key, value)
      end
    end
    
    private
    
    def get_property(name)
      self.class.properties[name.to_sym]
    end

    module ClassMethods

      def property(*args)
        # Prepare the property object and methods
        property = Property.new(*args)
        self.properties = properties.merge(property.name => property)
        define_property_methods(property)
        prepare_validation(property)
        property
      end

      protected

      def define_property_methods(property)
        # Getter
        define_method(property.name) do
          get_attribute(property.name) || property.default
        end
        # Setter
        define_method "#{property.name}=" do |value|
          set_attribute(property.name, value)
        end
      end

      def prepare_validation(property)
        if property.type.method_defined?(:valid?)
          validates_casted_attributes property.name
        end
      end

    end


  end
end
