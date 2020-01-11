require_relative 'validation.rb'

module TrainValidation
  include Validation

  private

  ACCELERATE_ERROR = 'Accelerate must be integer!'
  TYPE_MISMATCH_ERROR = 'Wrong Carrriage type!'
  SPEED_ERROR = 'You must stop to add/delete carriage!'
  CARRIAGES_SIZE_ERROR = 'No cars to delete!'
  NOT_EMPTY_CAR_ERROR = 'This car is not empty!'
  ROUTE_ERROR = 'No route specified!'
  NEXT_STATION_ERROR = 'There is no next station!'
  PREVIOUS_STATION_ERROR = 'There is no previous station!'

  def accelerate_validate!(value)
    raise ACCELERATE_ERROR unless value.is_a? Integer
  end

  def add_carriage_validate!(carriage)
    unless carriage.is_a?(Carriage) && attachable_carriage?(carriage)
      raise TYPE_MISMATCH_ERROR
    end
    raise SPEED_ERROR unless speed.zero?
  end

  def delete_carriage_validate!(carriage)
    raise SPEED_ERROR unless speed.zero?
    raise NOT_EMPTY_CAR_ERROR if carriage.reserved_capacity.positive?
    raise CARRIAGES_SIZE_ERROR unless carriages.size.positive?
  end

  def go_next_station_validate!
    raise ROUTE_ERROR if route.nil?
    raise NEXT_STATION_ERROR if route.stations[@current_station_index + 1].nil?
  end

  def go_previous_station_validate!
    raise ROUTE_ERROR if route.nil?
    raise PREVIOUS_STATION_ERROR unless @current_station_index.positive?
  end
end
