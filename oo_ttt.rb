require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def [](num)
    @squares[num]
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def offensive_move
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_identical_markers?(squares) &&
         two_identical_marker_type(squares) == TTTGame::COMPUTER_MARKER
        return line.select do |key|
          @squares[key].marker == Square::INITIAL_MARKER
        end.join.to_i
      end
    end
    nil
  end

  def defensive_move
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_identical_markers?(squares)
        return line.select do |key|
                 @squares[key].marker == Square::INITIAL_MARKER
               end.join.to_i
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop: disable Metrics/AbcSize
  # rubocop: disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop: enable Metrics/AbcSize
  # rubocop: enable Metrics/MethodLength

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def two_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 2
    markers.min == markers.max
  end

  def two_identical_marker_type(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    markers.min
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :score, :name, :marker

  def initialize(marker, name=nil)
    @marker = marker
    @score = 0
    @name = name
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER
  GRAND_WINNER_SCORE = 3

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    clear
    display_welcome_message
    sleep(4)
    clear
    main_game
    display_goodbye_message
  end

  private

  def main_game
    loop do
      play_loop
      announce_grand_winner
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def play_loop
    loop do
      display_board
      player_move
      increment_score
      display_result
      sleep(3)
      break if grand_winner?
      reset
    end
  end

  def grand_winner?
    human.score == GRAND_WINNER_SCORE || computer.score == GRAND_WINNER_SCORE
  end

  def announce_grand_winner
    if human.score == GRAND_WINNER_SCORE
      clear
      display_result
      puts "Congratulations, #{human.name}.  You are the Grand Winner!"
    else
      puts "#{computer.name} is the Grand Winner!"
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts "What is your name?"
    human.name = gets.chomp.capitalize
    puts "Welcome #{human.name}!"
    set_human_marker
    set_computer_name
    puts "First player to #{GRAND_WINNER_SCORE} points is the Grand Winner."
    puts ""
  end

  def set_computer_name
    name = ['Hal', 'T56', 'CompComp', 'Jim', 'Beevis', 'R2D2'].sample
    computer.name = name
    puts "You will be playing against a computer named #{computer.name}."
  end

  def set_human_marker
    puts "What marker will you use? (enter any single character):"
    answer = nil
    loop do
      answer = gets.chomp
      break if answer.length == 1 && answer != ' '
      puts "Please enter a single valid character:"
    end
    human.marker = answer
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def display_board
    puts "Your mark is #{human.marker}. #{computer.name} is #{computer.marker}."
    puts ""
    display_score
    board.draw
    puts ""
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def joinor(array)
    first_part = array[0..-2].join(', ')
    second_part = " or #{array[-1]}"
    return first_part + second_part if array.size > 1
    array[0]
  end

  def computer_moves
    if board.offensive_move
      board[board.offensive_move] = computer.marker
    elsif board.defensive_move
      board[board.defensive_move] = computer.marker
    elsif board.unmarked_keys.include?(5)
      board[5] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def display_score
    puts "#{human.name} score is : #{human.score}"
    puts "#{computer.name}'s score is: #{computer.score}"
    puts ""
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def increment_score
    case board.winning_marker
    when human.marker
      human.score += 1
    when computer.marker
      computer.score += 1
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system "clear"
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts "First player to #{GRAND_WINNER_SCORE} is the Grand Winner."
    puts ""
  end
end

game = TTTGame.new
game.play
