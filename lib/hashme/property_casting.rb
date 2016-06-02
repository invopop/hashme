module Hashme

  # Special property casting for reveiving data from sources without Ruby types, such as query
  # parameters from an API or JSON documents.
  #
  # Most of this code is stolen from CouchRest Model typecasting, with a few simplifications.
  module PropertyCasting
    extend self

    CASTABLE_TYPES = [String, Symbol, TrueClass, Integer, Float, BigDecimal, DateTime, Time, Date, Class]

    # Automatically typecast the provided value into an instance of the provided type.
    def cast(property, owner, value)
      return nil if value.nil?
      type = property.type
      if value.instance_of?(type) || type == Object
        value
      elsif CASTABLE_TYPES.include?(type)
        send('typecast_to_'+type.to_s.downcase, value)
      else
        # Complex objects we don't know how to cast
        type.new(value).tap do |obj|
          obj.casted_by = owner if obj.respond_to?(:casted_by=)
          obj.casted_by_property = property if obj.respond_to?(:casted_by_property=)
        end
      end
    end

    protected

    # Typecast a value to an Integer
    def typecast_to_integer(value)
      typecast_to_numeric(value, :to_i)
    end

    # Typecast a value to a BigDecimal
    def typecast_to_bigdecimal(value)
      typecast_to_numeric(value, :to_d)
    end

    # Typecast a value to a Float
    def typecast_to_float(value)
      typecast_to_numeric(value, :to_f)
    end

    # Convert some kind of object to a number that of the type
    # provided.
    #
    # When a string is provided, It'll attempt to filter out
    # region specific details such as commas instead of points
    # for decimal places, text units, and anything else that is
    # not a number and a human could make out.
    #
    # Esentially, the aim is to provide some kind of sanitary
    # conversion from values in incoming http forms.
    #
    # If what we get makes no sense at all, nil it.
    def typecast_to_numeric(value, method)
      if value.is_a?(String)
        value = value.strip.gsub(/,/, '.').gsub(/[^\d\-\.]/, '').gsub(/\.(?!\d*\Z)/, '')
        value.empty? ? nil : value.send(method)
      elsif value.respond_to?(method)
        value.send(method)
      else
        nil
      end
    end

    # Typecast a value to a String
    def typecast_to_string(value)
      value.to_s
    end

    def typecast_to_symbol(value)
      value.is_a?(Symbol) || !value.to_s.empty? ? value.to_sym : nil
    end

    # Typecast a value to a true or false
    def typecast_to_trueclass(value)
      if value.kind_of?(Integer)
        return true  if value == 1
        return false if value == 0
      elsif value.respond_to?(:to_s)
        return true  if %w[ true  1 t ].include?(value.to_s.downcase)
        return false if %w[ false 0 f ].include?(value.to_s.downcase)
      end
      nil
    end

    # Typecasts an arbitrary value to a DateTime.
    # Handles both Hashes and DateTime instances.
    # This is slow!! Use Time instead.
    def typecast_to_datetime(value)
      if value.is_a?(Hash)
        typecast_hash_to_datetime(value)
      else
        DateTime.parse(value.to_s)
      end
    rescue ArgumentError
      nil
    end

    # Typecasts an arbitrary value to a Date
    # Handles both Hashes and Date instances.
    def typecast_to_date(value)
      if value.is_a?(Hash)
        typecast_hash_to_date(value)
      elsif value.is_a?(Time) # sometimes people think date is time!
        value.to_date
      elsif value.to_s =~ /(\d{4})[\-|\/](\d{2})[\-|\/](\d{2})/
        # Faster than parsing the date
        Date.new($1.to_i, $2.to_i, $3.to_i)
      else
        Date.parse(value)
      end
    rescue ArgumentError
      nil
    end

    # Typecasts an arbitrary value to a Time
    # Handles both Hashes and Time instances.
    def typecast_to_time(value)
      case value
      when Float # JSON oj already parses Time, FTW.
        Time.at(value).utc
      when Hash
        typecast_hash_to_time(value)
      else
        typecast_iso8601_string_to_time(value.to_s)
      end
    rescue ArgumentError
      nil
    rescue TypeError
      nil
    end

    def typecast_iso8601_string_to_time(string)
      if (string =~ /(\d{4})[\-\/](\d{2})[\-\/](\d{2})[T\s](\d{2}):(\d{2}):(\d{2}(\.\d+)?)(Z| ?([\+\s\-])?(\d{2}):?(\d{2}))?/)
        # $1 = year
        # $2 = month
        # $3 = day
        # $4 = hours
        # $5 = minutes
        # $6 = seconds (with $7 for fraction)
        # $8 = UTC or Timezone
        # $9 = time zone direction
        # $10 = tz difference hours
        # $11 = tz difference minutes

        if $8 == 'Z' || $8.to_s.empty?
          Time.utc($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_r)
        else
          Time.new($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_r, "#{$9 == '-' ? '-' : '+'}#{$10}:#{$11}")
        end
      else
        Time.parse(string)
      end
    end

    # Creates a DateTime instance from a Hash with keys :year, :month, :day,
    # :hour, :min, :sec
    def typecast_hash_to_datetime(value)
      DateTime.new(*extract_time(value))
    end

    # Creates a Date instance from a Hash with keys :year, :month, :day
    def typecast_hash_to_date(value)
      Date.new(*extract_time(value)[0, 3].map(&:to_i))
    end

    # Creates a Time instance from a Hash with keys :year, :month, :day,
    # :hour, :min, :sec
    def typecast_hash_to_time(value)
      Time.utc(*extract_time(value))
    end

    # Extracts the given args from the hash. If a value does not exist, it
    # uses the value of Time.now.
    def extract_time(value)
      now = Time.now
      [:year, :month, :day, :hour, :min, :sec].map do |segment|
        typecast_to_numeric(value.fetch(segment, now.send(segment)), :to_i)
      end
    end

    # Typecast a value to a Class
    def typecast_to_class(value)
      value.to_s.constantize
    rescue NameError
      nil
    end

  end
end
