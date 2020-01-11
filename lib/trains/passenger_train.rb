require_relative 'train.rb'

class PassengerTrain < Train
  def initialize(number, company_name)
    super
  end

  def attachable_carriage?(carriage)
    carriage.is_a?(PassengerCarriage)
  end
end
