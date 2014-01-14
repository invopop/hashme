module Hashme
  module Castable
    extend ActiveSupport::Concern

    included do
      attr_accessor :casted_by
      attr_accessor :casted_by_property
    end
  end
end
