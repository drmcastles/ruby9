module Validation

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  EMPTY_NAME_ERROR = 'Name can not be empty!'
  INVALID_FORMAT_ERROR = 'Invalid format!'
  INVALID_TYPE_ERROR = 'Invalid type!'

  module ClassMethods
    # Накапливает параметры в массиве @validations
    #   :atr_name, :validation, option
    def validations
      @validations ||= []
    end

    def validate(name, type, *options)
      validations << { name: name, type: type, options: options }
    end
  end

  module InstanceMethods
    def validate!
      # Для каждой валидации запускаем соответствующий метод
      self.class.validations.each do |value|
        validation = "validate_#{value[:type]}"
        # В option пустой массив
        #   или массив доп опций
        option = value[:options]
        value = instance_variable_get("@#{value[:name]}".to_sym)
        send(validation, value, *option)
      end
    end

    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def validate_presence(value)
      raise EMPTY_NAME_ERROR if value.nil? || value.strip.empty?
    end

    def validate_format(value, format)
      raise INVALID_FORMAT_ERROR if value.nil? || value !~ format
    end

    def validate_type(value, type)
      raise INVALID_TYPE_ERROR unless value.is_a?(type)
    end
  end
end
