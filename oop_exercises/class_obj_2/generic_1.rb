#Modify the following code so that Hello! I'm a cat! is printed when Cat.generic_greeting is invoked.

class Cat

def self.generic_greeting
  puts "Hello, I am a data stored instance of the Cat class.  Not an actual cat."
end

end


kitty = Cat.new
Cat.generic_greeting
 kitty.class.generic_greeting

# Expected output:
# Hello! I'm a cat!