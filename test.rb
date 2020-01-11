require_relative 'lib/route.rb'
require_relative 'lib/station.rb'

require_relative 'lib/trains/passenger_train.rb'
require_relative 'lib/trains/cargo_train.rb'

require_relative 'lib/carriages/cargo_carriage.rb'
require_relative 'lib/carriages/passenger_carriage.rb'

require_relative 'lib/accessors.rb'
require_relative 'lib/validation/validation.rb'

class Test
  include Validation
  extend Acсessors
  attr_accessor_with_history :my_attr, :a, :b, :c
  #strong_attr_accessor a: Integer, b: Train

  validate(:number, :format, /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i)
  validate(:name, :type, String)
  validate(:name, :presence)
  def initialize(name, number)
    @name = name
    @number = number
    validate!
  end
end

# Test attr_accessor_with_history(*names)
# t = Test.new
# p t.a=1
# p t.a_history
# p t.a=nil
# p t.a_history
# p t.a=2
# p t.a_history
# p t.a=3
# p t.a_history

# Test Validation
t = Test.new("foo", "qaz12")

# t.a = 1
#p train = Train.new('asd', "qa")
#p train2 = CargoTrain.new('asd', "qa")
# t.b=train
# p t.a, t.b

# t.a=3
# t.a=5
# p t.a
# p t.a_history
# p t.a_history.last
