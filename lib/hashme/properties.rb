module Hashme
  module Properties
    extend ActiveSupport::Concern

    def get_attribute(name)
      self[name]
    end

    def set_attribute(name, value)
      property = get_property(name)
      if property.nil?
        self[name.to_sym] = value
      else
        self[property.name] = value.present? ?  property.cast(self, value) : value
      end
    end

    protected

    # Internal method to go through each attribute and set the
    # values via the set_attribute method.
    def set_attributes(attrs = {})
      attrs.each do |key, value|
        set_attribute(key, value)
      end
    end
    
    private
    
    def get_property(name)
      # not only search in the class, search in the superclass too if the superclass can respond to properties[]. Using a class method for this
      self.class.search_property(name)
    end

    module ClassMethods

      attr_accessor :properties

      def property(*args)
        self.properties ||= {}

        # Prepare the property object and methods
        property = Property.new(*args)
        properties[property.name] = property
        define_property_methods(property)

        property
      end
      
      # Recursive search the property in the superclass chain
      def search_property(name)        
        name = name.to_sym
        
        if properties[name]
          properties[name]
        elsif superclass.respond_to?(:search_property)
          superclass.search_property(name)
        else
          nil
        end
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

    end


  end
end
