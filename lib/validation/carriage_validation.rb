require_relative 'validation.rb'

module CarriageValidation
  include Validation

  private

  CAPACITY_ERROR = 'Capacity must be positive number!'
  RESERVE_CAPACITY_ERROR = 'Not enough space!'
  RESERVE_CAPACITY_FORMAT_ERROR = 'Enter a positive number to reserve capacity!'

  def validate!
    super
    raise CAPACITY_ERROR unless capacity.is_a?(Integer) && capacity.positive?
  end

  def reserve_capacity_validatie!(volume)
    unless volume.is_a?(Integer) && volume.positive?
      raise RESERVE_CAPACITY_FORMAT_ERROR
    end
    raise RESERVE_CAPACITY_ERROR if volume > available_capacity
  end
end
