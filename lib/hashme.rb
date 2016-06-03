require "hashme/version"

# External dependencies

require "active_model"
require "active_model/naming"
require "active_model/serialization"

require "active_support/core_ext"
require "active_support/json"

# Local dependencies

require "hashme/attributes"
require "hashme/casted_array"
require "hashme/properties"
require "hashme/property"
require "hashme/property_casting"
require "hashme/validations/casted_attribute_validator"
require "hashme/validations"

module Hashme
  extend ActiveSupport::Concern

  include Validations

  included do
    include Attributes
    include Properties
  end

  def initialize(attrs = {})
    # Use the `Properties` module's methods
    set_defaults
    set_attributes(attrs)
  end

  module ClassMethods
    # Little help. Equivalent to new.tap
    def build(*attrs)
      instance = self.new(*attrs)
      yield instance if block_given?
      instance
    end
  end
end
