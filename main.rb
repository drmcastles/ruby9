require_relative 'lib/route.rb'
require_relative 'lib/station.rb'

require_relative 'lib/trains/passenger_train.rb'
require_relative 'lib/trains/cargo_train.rb'

require_relative 'lib/carriages/cargo_carriage.rb'
require_relative 'lib/carriages/passenger_carriage.rb'

class Main
  def main_menu
    loop do
      show_menu(MAIN_MENU, 'Main menu:')
      case gets.to_i
      when 1 then station_menu
      when 2 then train_menu
      when 3 then route_menu
      when 0 then exit
      else puts 'Input error.'
      end
    end
  end

  private

  # MENU
  MAIN_MENU = [
    'Station menu',
    'Train menu',
    'Route menu'
  ]

  STATION_MENU = [
    'Create station',
    'View stations',
    'View trains on station'
  ]

  TRAIN_MENU = [
    'Create train',
    'Assign Train to the route',
    'Add carriage to the train',
    'Cargo / seats reservation',
    'Remove carriage from the train',
    'Move the train'
  ]

  ROUTE_MENU = [
    'Create route',
    'Add intermediate station to route',
    'Delete intermediate station from route',
    'View routes'
  ]

  TRAIN_TYPE_MENU = [
    'Create cargo train',
    'Create passenger train'
  ]

  DIRECTION_MENU = [
    'Go next station',
    'Go previous station'
  ]

  CREATE_ROUTE_STATION_MENU = [
    'Add existing station to route',
    'Create a new one and add to route'
  ]

  STATIONS_ERROR = 'Create at least one Station!'
  TRAINS_ERROR = 'Create at least one Train!'
  ROUTES_ERROR = 'Create at least one Route!'
  NO_CARRIAGES_ERROR = 'This train has no cars!'

  attr_reader :trains, :routes, :stations

  def initialize
    @trains = []
    @routes = []
    @stations = []
  end

  # Functional menu
  def station_menu
    loop do
      show_menu(STATION_MENU, 'Station menu:')
      case gets.to_i
      when 1 then create_station
      when 2 then show_stations
      when 3 then trains_on_station
      when 0 then return
      else puts 'Input error!'
      end
    end
  end

  def train_menu
    loop do
      show_menu(TRAIN_MENU, 'Train menu:')
      case gets.to_i
      when 1 then create_train
      when 2 then assign_train
      when 3 then add_carriage
      when 4 then carriage_reservation
      when 5 then delete_carriage
      when 6 then train_go
      when 0 then return
      else puts 'Input error!'
      end
    end
  end

  def route_menu
    loop do
      show_menu(ROUTE_MENU, 'Route menu:')
      case gets.to_i
      when 1 then create_route
      when 2 then add_route_station
      when 3 then delete_route_station
      when 4 then show_routes
      when 0 then return
      else puts 'Input error!'
      end
    end
  end

  # Station menu methods
  def create_station
    puts 'Enter station name:'
    name = gets.chomp
    new_station = Station.new(name)
    stations << new_station
    puts "You create a station: #{new_station.name}."
    new_station
  rescue RuntimeError => e
    puts e.message
  end

  def show_stations
    stations_validate!
    show_array(stations)
  rescue RuntimeError => e
    puts e.message
  end

  def trains_on_station
    station = select_from_stations(stations)
    station_info(station)
    station.each_train do |train|
      train_info(train)
      train.each_carriage { |carriage| carriage_info(carriage) }
    end
  rescue RuntimeError => e
    puts e.message
  end

  # Train menu methods
  def create_train
    puts 'Enter train number and train name:'
    number, name = gets.chomp.split(' ')
    show_menu(TRAIN_TYPE_MENU, 'Select train type:')
    case gets.to_i
    when 1 then trains << CargoTrain.new(number, name)
    when 2 then trains << PassengerTrain.new(number, name)
    when 0 then return
    else raise 'Input error!'
    end
    train_info(trains.last)
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def assign_train
    train = select_from_trains(trains)
    route = select_from_routes(routes)
    train.add_route(route)
    train_info(train)
    route_info(route)
  rescue RuntimeError => e
    puts e.message
  end

  def create_carriage(train)
    puts 'Enter carriage name and carriage capacity:'
    name, value = gets.chomp.split(' ')
    case train
    when CargoTrain then CargoCarriage.new(name, value.to_i)
    when PassengerTrain then PassengerCarriage.new(name, value.to_i)
    end
  end

  def add_carriage
    train = select_from_trains(trains)
    train.add_carriage(create_carriage(train))
    train_info(train)
    train.each_carriage { |car| carriage_info(car) }
  rescue RuntimeError => e
    puts e.message
  end

  def carriage_reservation
    train = select_from_trains(trains)
    carriage = select_from_carriages(train.carriages)
    case carriage
    when CargoCarriage then capacity_reservation(carriage)
    when PassengerCarriage then carriage.reserve_capacity
    end
    train_info(train)
    carriage_info(carriage)
  rescue RuntimeError => e
    puts e.message
  end

  def capacity_reservation(carriage)
    puts 'Enter cargo volume:'
    volume = gets.to_i
    carriage.reserve_capacity(volume)
  end

  def delete_carriage
    train = select_from_trains(trains)
    carriage = select_from_carriages(train.carriages)
    train.delete_carriage(carriage)
    train_info(train)
    train.each_carriage { |car| carriage_info(car) }
  rescue RuntimeError => e
    puts e.message
  end

  def train_go
    train = select_from_trains(trains)
    show_menu(DIRECTION_MENU, 'Choose a direction:')
    case gets.to_i
    when 1 then move_train_to_next_station(train)
    when 2 then move_train_to_previous_station(train)
    when 0 then return
    else raise 'Input error!'
    end
    train_info(train)
  rescue RuntimeError => e
    puts e.message
  end

  def move_train_to_next_station(train)
    train.go_next_station
  end

  def move_train_to_previous_station(train)
    train.go_previous_station
  end

  # Route menu methods
  def create_route
    start_station = select_or_create_station('Start station:')
    last_station = select_or_create_station('Last station:')
    route = Route.new(start_station, last_station)
    routes << route
    route_info(route)
  rescue RuntimeError => e
    puts e.message
  end

  def add_route_station
    route = select_from_routes(routes)
    station = select_or_create_station('Station:')
    route.add_station(station)
    route_info(route)
  rescue RuntimeError => e
    puts e.message
  end

  def delete_route_station
    route = select_from_routes(routes)
    station = select_from_stations(route.stations)
    route.delete_station(station)
    route_info(route)
  rescue RuntimeError => e
    puts e.message
  end

  def select_or_create_station(title)
    show_menu(CREATE_ROUTE_STATION_MENU, title)
    case gets.to_i
    when 1 then select_from_stations(stations)
    when 2 then create_station
    else raise 'Input error!'
    end
  end

  def show_routes
    routes_validate!
    show_array(routes)
  rescue RuntimeError => e
    puts e.message
  end

  # Utilities
  # Show menu
  def show_menu(menu, title = nil)
    puts title if title
    menu.each.with_index(1) do |item, index|
      puts "#{index}. #{item}"
    end
    puts '0. Exit'
  end

  def show_array(array)
    puts 'All items:'
    array.each.with_index(1) do |item, index|
      print "#{index}. "
      info(item)
    end
  end

  def select_from_array(array)
    show_array(array)
    puts "Enter Index -> (1 - #{array.size})"
    index = gets.to_i
    raise 'Input error!' unless index.between?(1, array.size)

    array[index - 1]
  rescue RuntimeError => e
    puts e.message
    retry
  end

  # Selectors
  def select_from_stations(stations)
    stations_validate!
    select_from_array(stations)
  end

  def select_from_trains(trains)
    trains_validate!
    select_from_array(trains)
  end

  def select_from_carriages(carriages)
    carriages_validate!(carriages)
    select_from_array(carriages)
  end

  def select_from_routes(routes)
    routes_validate!
    select_from_array(routes)
  end

  # Validators
  def stations_validate!
    raise STATIONS_ERROR if stations.empty?
  end

  def trains_validate!
    raise TRAINS_ERROR if trains.empty?
  end

  def carriages_validate!(carriages)
    raise NO_CARRIAGES_ERROR if carriages.empty?
  end

  def routes_validate!
    raise ROUTES_ERROR if routes.empty?
  end

  # Info methods
  def info(item)
    case item
    when Station then station_info(item)
    when Train then train_info(item)
    when Route then route_info(item)
    when Carriage then carriage_info(item)
    end
  end

  def train_info(train)
    puts "Train -> Number: #{train.number}; " \
      "CompanyName: #{train.company_name}; " \
      "Type: #{train.class}; " \
      "Number of carriages: #{train.carriages.size};"
    train_route_info(train) if train.route
  end

  def train_route_info(train)
    prev_station = train.previous_station ? train.previous_station.name : 'N/D'
    current_station = train.current_station.name
    next_station =  train.next_station ? train.next_station.name : 'N/D'
    puts "Previous station: #{prev_station}; " \
         "Current station: #{current_station}; " \
         "Next station: #{next_station};"
  end

  def carriage_info(car)
    puts "Carriage -> Number: #{car.number}; " \
         "CompanyName: #{car.company_name}; " \
         "Type: #{car.class}; " \
         "Available capacity: #{car.available_capacity}; " \
         "Reserved capacity: #{car.reserved_capacity};"
  end

  def route_info(route)
    print 'Route '
    route.stations.each { |station| print "->#{station.name}" }
    puts
  end

  def station_info(station)
    puts "Station: #{station.name}"
  end

  # def seed
  #   a = Station.new('a')
  #   b = Station.new('b')
  #   c = Station.new('c')
  #   d = Station.new('d')
  #   e = Station.new('e')
  #   f = Station.new('f')
  #   g = Station.new('g')
  #   h = Station.new('h')
  #   stations << a << b << c << d << e << f << g << h

  #   train1 = CargoTrain.new('abc-01', 'companyname')
  #   train2 = PassengerTrain.new('abc-02', 'companyname')
  #   train3 = CargoTrain.new('abc-03', 'companyname')
  #   train4 = PassengerTrain.new('abc-04', 'companyname')
  #   trains << train1 << train2 << train3 << train4

  #   route1 = Route.new(a, d)
  #   route2 = Route.new(e, h)
  #   route3 = Route.new(f, g)
  #   route4 = Route.new(c, e)
  #   routes << route1 << route2 << route3 << route4

  #   train1.add_route(route1)
  #   train2.add_route(route2)
  #   train3.add_route(route3)
  #   train4.add_route(route4)

  #   car1 = PassengerCarriage.new('car1', 10)
  #   car2 = PassengerCarriage.new('car2', 9)
  #   car3 = PassengerCarriage.new('car3', 8)

  #   car11 = CargoCarriage.new('car11', 10)
  #   car22 = CargoCarriage.new('car22', 12)
  #   car33 = CargoCarriage.new('car33', 14)
  #   train1.add_carriage(car11)
  #   train1.add_carriage(car22)
  #   train1.add_carriage(car33)
  #   train2.add_carriage(car1)
  #   train2.add_carriage(car2)
  #   train2.add_carriage(car3)
  #   main_menu
  # end
end

main = Main.new
main.main_menu
#main.seed
