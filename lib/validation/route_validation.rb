require_relative 'validation.rb'

module RouteValidation
  include Validation

  private

  TYPE_MISMATCH_ERROR = 'Route elements must be Station type objects!'
  DUPLICATE_ERROR = 'There is already such a station in the route!'
  DELETE_ERROR = 'Can not delete start or last stations!'

  private

  def validate!
    super
    unless stations.all? { |station| station.is_a?(Station) }
      raise TYPE_MISMATCH_ERROR
    end
    raise DUPLICATE_ERROR if stations.first == stations.last
  end

  def delete_station_validate!(station)
    raise DELETE_ERROR if [first_station, last_station].include?(station)
  end

  def add_station_validate!(station)
    raise TYPE_MISMATCH_ERROR unless station.is_a?(Station)
    raise DUPLICATE_ERROR if stations.include?(station)
  end
end
