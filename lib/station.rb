require_relative 'instance_counter.rb'
require_relative 'validation/station_validation.rb'
require_relative 'accessors.rb'
class Station
  include InstanceCounter
  include Validation
  include StationValidation
  extend Acсessors

  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  validate :name, :presence

  def initialize(station_name)
    @name = station_name
    @trains = []
    register_instance
    validate!
    @@stations << self
    register_instance
  end

  def trains_on_station
    trains_on_station_validate!
    trains
  end

  def trains_by_type(type)
    trains_on_station_validate!
    trains.count { |train| train.is_a?(type) }
  end

  def delete_train(train)
    trains.delete(train)
  end

  def train_in(train)
    trains << train
  end

  def each_train
    trains_on_station_validate!
    trains.each { |train| yield(train) }
  end
end
