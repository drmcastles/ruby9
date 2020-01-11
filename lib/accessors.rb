module Acсessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_history = "@#{name}_history".to_sym
      raise TypeError, 'Name is not symbol' unless name.is_a?(Symbol)

      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}_history") { instance_variable_get(var_history) }
      define_method("#{name}=") do |value|
        if send("#{name}_history").nil?
          instance_variable_set(var_history, [])
        else
          instance_variable_get(var_history) << send(name.to_s)
        end
        instance_variable_set(var_name, value)
      end
    end
  end

  def strong_attr_accessor(hash)
    hash.each do |name, type|
      var_name = "@#{name}".to_sym
      raise TypeError, 'Name is not symbol' unless name.is_a?(Symbol)

      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=") do |value|
        raise TypeError unless value.is_a?(type)

        instance_variable_set(var_name, value)
      end
    end
  end
end
