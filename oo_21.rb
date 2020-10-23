class Deck
  SUITS = ['H', 'D', 'C', 'S']
  VALUES = ['2', '3', '4', '5', '6', '7', '8',
            '9', '10', 'Jack', 'Queen', 'King', 'Ace']

  attr_reader :cards

  def initialize
    @cards = []
    SUITS.each do |suit|
      VALUES.each do |value|
        @cards << [suit, value]
      end
    end
  end

  def deal_two
    two_cards = cards.sample(2)
    cards.delete(two_cards[0])
    cards.delete(two_cards[1])
    two_cards
  end

  def deal_one
    one_card = cards.sample
    cards.delete(one_card)
  end
end

class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def translate_card
    "#{value} of #{suit_translation}"
  end

  def suit_translation
    if suit == 'H'
      'Hearts'
    elsif suit == 'D'
      'Diamonds'
    elsif suit == 'C'
      'Clubs'
    else
      'Spades'
    end
  end
end

class Participant
  attr_accessor :hand, :name

  def initialize(hand)
    @hand = hand
    @name = name
  end

  def busted?
    total > 21
  end

  def total
    card_object_array = convert_cards
    tally_cards(card_object_array)
  end

  def convert_cards
    player_cards = []
    hand.each do |card|
      player_cards << Card.new(card[0], card[1])
    end
    player_cards
  end

  def tally_cards(card_object_array)
    tally = 0
    card_object_array.each do |card|
      if ace?(card) && tally <= 10
        tally += 11
      elsif ace?(card) && tally > 10
        tally += 1
      elsif face?(card)
        tally += 10
      else
        tally += card.value.to_i
      end
    end
    tally
  end

  def face?(card)
    card.value == 'Jack' || card.value == 'Queen' || card.value == 'King'
  end

  def number_card?(card)
    card.value.to_i.to_s == card.value
  end

  def ace?(card)
    card.value == 'Ace'
  end
end

class Game < Participant
  attr_reader :deck, :dealer, :player

  def initialize
    @deck = Deck.new
    @dealer = Participant.new(deck.deal_two)
    @player = Participant.new(deck.deal_two)
  end

  def start
    welcome_to_game
    loop do
      show_initial_cards
      player_turn
      dealer_turn
      show_result
      break unless play_again?
      reset
    end
    goodbye_message
  end

  private

  def goodbye_message
    puts "Thanks for playing 21, #{player.name}!  Good Bye."
  end

  def reset
    clear
    puts "Let's play again!"
    deck = Deck.new
    dealer.hand = deck.deal_two
    player.hand = deck.deal_two
    sleep(2)
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y n)"
      answer = gets.chomp
      break if %(y n).include? answer
      puts "Please enter y or n."
    end
    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def show_initial_cards
    clear
    puts "#{dealer.name} is showing:\n\n#{cards_dealer_shows}"
    puts ""
    puts "You have:\n\n#{translated_cards(player)}"
    puts ""
  end

  def player_turn
    loop do
      answer = retrieve_player_input
      player_hit if answer == 'h'
      break if answer == 's'
      cards_player_sees
      break if @player.busted?
    end
  end

  def retrieve_player_input
    answer = nil
    puts "#{player.name}, would you like to hit or stay? (h/s)"
    loop do
      answer = gets.chomp
      break if ['h', 's'].include?(answer.downcase)
      puts "Please enter a valid input (h/s):"
    end
    answer
  end

  def cards_player_sees
    print_partial_dealer_hand
    print_player_hand
    puts "#{player.name} busted.  #{dealer.name} Wins.\n\n" if player.busted?
  end

  def print_partial_dealer_hand
    clear
    puts "#{dealer.name} is showing:\n\n#{cards_dealer_shows}\n\n"
  end

  def translated_cards(player)
    translation = []
    player.hand.each do |card|
      card = Card.new(card[0], card[1])
      translation << card.translate_card
    end
    translation.join("\n")
  end

  def player_hit
    @player.hand += [@deck.deal_one]
  end

  def dealer_hit
    @dealer.hand += [@deck.deal_one]
  end

  def cards_dealer_shows
    cards = translated_cards(dealer).split("\n")
    (cards - [cards[0]]).join("\n")
  end

  def dealer_turn
    return nil if player.busted?
    clear
    sleep(1)
    loop do
      dealer_thinks
      break if @dealer.total >= 17
    end
  end

  def dealer_thinks
    dealer_hit if @dealer.total < 17
    print_partial_dealer_hand
    puts "#{dealer.name} stays." if dealer_stays?
    puts "" if dealer_stays?
    sleep(2)
  end

  def dealer_stays?
    @dealer.total >= 17 && @dealer.total <= 21
  end

  def print_final_score
    puts "#{dealer.name}'s score is: #{dealer.total}"
    puts "#{player.name}'s score is: #{player.total}"
  end

  def show_result
    return nil if player.busted?
    clear
    print_dealer_hand
    return unless @dealer.total <= 21
    print_player_hand
    print_final_score
    puts ""
    puts announce_winner
  end

  def announce_winner
    if dealer.total > player.total
      "#{dealer.name} Wins.\n\n"
    elsif player.total > dealer.total
      "#{player.name} Wins!\n\n"
    else
      "It's a tie.\n\n"
    end
  end

  def print_player_hand
    puts "You have: \n\n#{translated_cards(player)}"
    puts ""
  end

  def print_dealer_hand
    puts "#{dealer.name} has:\n\n#{translated_cards(dealer)}"
    puts ""
    puts "#{dealer.name} Busted\n\n" if @dealer.total > 21
  end

  def welcome_to_game
    clear
    puts "Welcome to the game of 21.\n\n"
    assign_player_name
    assign_dealer_name
    puts ""
    puts "Welcome #{player.name}."
    puts "Your dealer's name is #{dealer.name}."
    sleep(3)
    clear
  end

  def assign_player_name
    puts "Please enter your name:"
    answer = nil
    loop do
      answer = gets.chomp
      break unless answer.nil?
      puts "Please enter a value for your name."
    end
    player.name = answer
  end

  def assign_dealer_name
    dealer.name = ['Jim', 'Hooligan', 'Kim',
                   'Starflower', 'Cyberdeal_2000'].sample
  end
end

Game.new.start
