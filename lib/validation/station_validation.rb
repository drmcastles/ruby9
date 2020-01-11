require_relative 'validation.rb'

module StationValidation
  include Validation

  private

  TRAINS_ERROR = 'There are no trains at this station!'
  DUPLICATE_ERROR = 'This station already exist!'
  private

  def validate!
    super
    if self.class.all.any? { |station| station.name == name }
      raise DUPLICATE_ERROR
    end
  end

  def trains_on_station_validate!
    raise TRAINS_ERROR if trains.empty?
  end
end
