module Hashme
  module Validations
    class CastedAttributeValidator < ActiveModel::EachValidator
      
      def validate_each(document, attribute, value)
        values = value.is_a?(Array) ? value : [value]
        return if values.collect {|attr| attr.nil? || attr.valid? }.all?
        document.errors.add(attribute)
      end

    end
  end
end
