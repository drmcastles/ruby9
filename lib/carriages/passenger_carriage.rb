require_relative 'carriage.rb'
class PassengerCarriage < Carriage
  def initialize(company_name, seats)
    super
  end

  def reserve_capacity
    super(1)
  end
end
