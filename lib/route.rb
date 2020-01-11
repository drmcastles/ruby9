require_relative 'instance_counter.rb'
require_relative 'validation/route_validation.rb'
require_relative 'accessors.rb'

class Route
  include InstanceCounter
  include Validation
  include RouteValidation
  extend Acсessors

  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
    register_instance
  end

  def first_station
    stations.first
  end

  def last_station
    stations.last
  end

  def add_station(station)
    add_station_validate!(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    delete_station_validate!(station)
    stations.delete(station)
  end
end
