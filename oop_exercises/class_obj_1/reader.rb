#Using the code from the previous exercise, add a getter method named #name and invoke it in place of @name in #greet.


class Cat
  attr_reader :name

  def initialize(name)
    @name = name
   end

  def greet
    puts "Hello, my name is #{name}, I'm a cat!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet


# Expected output:
# Hello! My name is Sophie!