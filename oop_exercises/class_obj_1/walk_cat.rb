# Using the following code, create a module named Walkable that contains a method named #walk. This method should 
# print Let's go for a walk! when invoked. Include Walkable in Cat and invoke #walk on kitty.

module Walkable

  def walk
    puts "I'm a giant walking cat named #{self.name}.  Let's walk."
  end

end

class Cat
  attr_accessor :name
  include Walkable

  def initialize(name)
    @name = name
   end

  def greet
    puts "Hello, my name is #{name}, I'm a giant!"
  end


end

kitty = Cat.new('Sophie')
kitty.greet
kitty.walk


# Expected output:
# Hello! My name is Sophie!
# Let's go for a walk!