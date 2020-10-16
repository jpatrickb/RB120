

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  
  def initialize(move_type)
    @value = move_type
  end

  def scissors?
    @value == 'scissors' 
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def >(other_move)
    if rock?
      other_move.scissors? || other_move.lizard?
    elsif paper?
      other_move.rock? || other_move.spock?
    elsif scissors?
      other_move.paper? || other_move.lizard?
    elsif lizard?
      other_move.spock? || other_move.paper?
    elsif spock?
      other_move.scissors? || other_move.rock?
    end
  end

  def <(other_move)
    if rock?
      other_move.paper? || other_move.spock?
    elsif paper?
      other_move.scissors? || other_move.lizard?
    elsif scissors?
      other_move.rock? || other_move.spock?
    elsif lizard?
      other_move.rock? || other_move.scissors?
    elsif spock?
      other_move.paper? || other_move.lizard?
    end
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score
  attr_reader :move_history 
  
  def initialize
    @score = 0
    set_name
    @move_history = []
  end

  def add_to_history(move)
    @move_history << move.to_s
  end

end

class Human < Player
  def set_name
    n = ''
      loop do
        puts "What is your name?"
        n = gets.chomp
        break unless n.empty?
        puts "Sorry, must enter a value"
      end
      self.name = n
  end

  def choose
    choice = nil
      loop do
        puts "#{name}, please choose rock, paper, scissors, lizard, or spock:"
        choice = gets.chomp
        break if Move::VALUES.include? choice
        puts "Sorry, invalid choice."
      end
    self.move = Move.new(choice)
    self.add_to_history(move)
  end

  
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    case name
    when 'R2D2'
      self.move = Move.new('rock')
    else
      self.move = Move.new(Move::VALUES.sample)
    end
    self.add_to_history(move)
  end
end


class RPSGame
  GRAND_WINNER_SCORE = 5
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock:"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock! Goodbye."
  end

  def display_winner
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."

    if human.move > computer.move
      puts "#{human.name} won!"
      human.score += 1
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      computer.score += 1
    else
      puts "It's a tie!"
    end
  end

  def display_score
    puts "#{human.name}'s score is: #{human.score}"
    puts "#{computer.name}'s score is: #{computer.score}"
  end

  def grand_winner?(player)
    player.score == GRAND_WINNER_SCORE 
  end

  def announce_grand_winner
    if grand_winner?(human)
      puts "#{human.name} is the Grand Winner."
    elsif grand_winner?(computer)
      puts "#{computer.name} is the Grand Winner."
    end
  end
    
  def grand_winner_exist?
    grand_winner?(human) || grand_winner?(computer)
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def display_move_history
    puts "So far#{computer.name} has moved #{computer.move_history}"
    puts "So far #{human.name} has moved #{human.move_history}"
  end

  def play
    display_welcome_message
    loop do
      loop do
        system 'clear'
        display_score
        human.choose
        computer.choose
        display_winner
        display_score if grand_winner_exist?
        announce_grand_winner
        sleep(2)
        break if grand_winner_exist? 
      end 
    break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play