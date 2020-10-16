#Consider the following code:

class Pet
  attr_reader :pet_type, :pet_name

  def initialize(pet_type, pet_name)
    @pet_type = pet_type
    @pet_name = pet_name
  end

  def to_s
    "a #{pet_type} named #{pet_name}"
  end
end

class Owner
  attr_reader :name, :pets_owned

  def initialize(name)
    @name = name
    @pets_owned = []
  end

  def number_of_pets
    @pets_owned.size
  end

  def add_pet(pet)
    pets_owned << pet
  end

  def print_pets
    pets_owned.each do |pet|
      puts pet
    end
  end
end

class Shelter

  def initialize
    @owners = []
    @unadopted_pets = []
  end
  
  def adopt(owner, pet)
    owner.add_pet(pet)
    @owners << owner unless @owners.include?(owner)
    @unadopted_pets.delete(pet)
  end

  def list_unadopted
    @unadopted_pets.each do |pet|
      puts pet
    end
  end

  def take_in_animal(pet)
    @unadopted_pets << pet
  end

  def print_adoptions
    @owners.each do |owner|
      puts "#{owner.name} has the following pets:"
      owner.print_pets
      puts ""
    end
  end

  def print_unadopted_pets
    puts "This shelter has the following unadopted pets:"
    list_unadopted
    end



end






butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

asta         = Pet.new('dog', 'Asta')
laddie       = Pet.new('dog', 'Laddie')
fluffy       = Pet.new('cat', 'Fluffy')
kat          = Pet.new('cat', 'Kat')
ben          = Pet.new('cat', 'Ben')
chatterbox   = Pet.new('parakeet', 'Chatterbox')
bluebell     = Pet.new('parakeet', 'Bluebell')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')
jbrereton = Owner.new('J Brereton')

shelter = Shelter.new

[asta, laddie, fluffy, kat, ben, chatterbox, bluebell].each do |pet|
shelter.take_in_animal(pet)
end

shelter.adopt(jbrereton, chatterbox)
shelter.adopt(jbrereton, kat)
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
shelter.print_unadopted_pets
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."

# Write the classes and methods that will be necessary to make this code run, and print the following output:

# P Hanson has adopted the following pets:
# a cat named Butterscotch
# a cat named Pudding
# a bearded dragon named Darwin

# B Holmes has adopted the following pets:
# a dog named Molly
# a parakeet named Sweetie Pie
# a dog named Kennedy
# a fish named Chester

# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.

# The order of the output does not matter, so long as all of the information is presented.

