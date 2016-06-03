module Hashme
  module Validations
    class CastedAttributeValidator < ActiveModel::EachValidator
      
      def validate_each(document, attribute, value)
        is_array = value.is_a?(Array) || value.is_a?(CastedArray)
        values = is_array ? value : [value]
        return if values.collect {|attr| attr.nil? || attr.valid? }.all?
        document.errors.add(attribute)
      end

    end
  end
end
