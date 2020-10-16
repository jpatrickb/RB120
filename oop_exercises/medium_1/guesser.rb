# Create an object-oriented number guessing class for numbers in the range 1 to 100, with 
# a limit of 7 guesses per game. The game should play like this:

# Note that a game object should start a new game with a new number to guess with each call to #play.
require 'pry'

class GuessingGame

  def initialize
    @guesses = 7
    @number = rand(100)
  end

  def reset
    @guesses = 7
    @number = rand(100)
    @guess = nil
    @replay = nil
  end

  def announce_guesses
    puts "You have #{@guesses} guesses remaining."
  end

  def retrieve_number
    puts "Enter a number between 1 and 100:"
    answer = nil
      loop do 
        answer = gets.chomp.to_i
        break if (1..100).include?(answer)
        puts "Please enter a valid guess:"
      end
    @guess = answer
    @guesses -= 1
  end

  def report_result
    if @guess < @number
      puts "Your guess is too low."
    elsif @guess > @number
      puts "Your guess is too high."
    elsif @guess == @number
      puts "That's the number!"
    elsif @guesses == 0
      puts "You are out of guesses.  Game over."
    end
  end

  def winner?
    @guess == @number
  end

  def play_again
    if winner?
      puts "Congratulations on winning." 
      replay?
    else
      puts "You are out of guesses. Sorry for your loss."
      replay?
    end
  end
  
  def replay?
    puts"Would you like to play again? (y n):"
    answer = nil
    loop do 
      answer = gets.chomp
      break if %(y n).include?(answer)
      puts "Please enter a vaild response."
    end
    @replay = answer
  end



  def play
    loop do
      reset
      loop do
        announce_guesses
        retrieve_number
        report_result
        break if winner? || @guesses == 0
      end
      play_again
      break unless @replay == 'y'
    end
  end

end

game = GuessingGame.new
game.play


# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# That's the number!

# You won!

#game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high.

# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have 1 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have no more guesses. You lost!