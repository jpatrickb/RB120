#Consider the following classes:
class Vehicle
  attr_reader :make, :model
  
  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end

  def wheels
    self.class::WHEELS
  end
end

class Car < Vehicle
  WHEElS = 4
end

class Motorcycle < Vehicle
  WHEELS = 2
end

class Truck < Vehicle
  WHEELS = 6
  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end
end


#Refactor these classes so they all use a common superclass, and inherit behavior as needed.

truck =Truck.new('Big', 'Honker', 10000)
p truck.wheels