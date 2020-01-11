require_relative '../company_name.rb'
require_relative '../instance_counter.rb'
require_relative '../validation/train_validation.rb'
require_relative '../accessors.rb'

class Train
  include CompanyName
  include InstanceCounter
  include Validation
  include TrainValidation
  extend Acсessors

  NUMBER_FORMAT = /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i

  attr_reader :number, :speed, :route, :carriages

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end
  # Не работае
  validate(:company_name, :presence)
  validate(:number, :format, NUMBER_FORMAT)

  def initialize(number, company_name)
    @number = number
    @company_name = company_name
    @speed = 0
    @current_station = nil
    @route = nil
    @carriages = []
    validate!
    register_instance
    @@trains[number] = self
  end

  def accelerate(value)
    accelerate_validate!(value)
    @speed += value
    @speed = 0 if @speed.negative?
  end

  def stop
    @speed = 0
  end

  def add_carriage(carriage)
    add_carriage_validate!(carriage)
    carriages << carriage
  end

  def delete_carriage(carriage)
    delete_carriage_validate!(carriage)
    carriages.delete(carriage)
  end

  def current_station
    route.stations[@current_station_index]
  end

  def add_route(route)
    @route = route
    @current_station_index = 0
    current_station.train_in(self)
  end

  def next_station
    route.stations[@current_station_index + 1]
  end

  def previous_station
    return unless @current_station_index.positive?

    route.stations[@current_station_index - 1]
  end

  def go_next_station
    go_next_station_validate!
    current_station.delete_train(self)
    @current_station_index += 1
    current_station.train_in(self)
  end

  def go_previous_station
    go_previous_station_validate!
    current_station.delete_train(self)
    @current_station_index -= 1
    current_station.train_in(self)
  end

  def each_carriage
    carriages.each { |car| yield(car) }
  end
end
