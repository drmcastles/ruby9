require_relative '../company_name.rb'
require_relative '../validation/carriage_validation.rb'
require_relative '../accessors.rb'

class Carriage
  include CompanyName
  include Validation
  include CarriageValidation
  extend Acсessors

  attr_reader :number, :capacity, :reserved_capacity

  validate :company_name, :presence

  def initialize(company_name, capacity)
    @company_name = company_name
    @number = 5.times.map { rand(10) }.join
    @capacity = capacity
    @reserved_capacity = 0
    validate!
  end

  def reserve_capacity(volume)
    reserve_capacity_validatie!(volume)
    @reserved_capacity += volume
  end

  def available_capacity
    @capacity - @reserved_capacity
  end
end
