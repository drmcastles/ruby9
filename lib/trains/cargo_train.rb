require_relative 'train.rb'

class CargoTrain < Train
  def initialize(number, company_name)
    super
  end

  def attachable_carriage?(carriage)
    carriage.is_a?(CargoCarriage)
  end
end
