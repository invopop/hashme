module Hashme

  # Additional functionality for validation outside the standard ActiveModel stuff.
  module Validations
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    module ClassMethods

      # Validates the associated casted model. This method should not be
      # used within your code as it is automatically included when a CastedModel
      # is used inside the model.
      def validates_casted_attributes(*args)
        validates_with(CastedAttributeValidator, _merge_attributes(args))
      end

    end

  end

end
