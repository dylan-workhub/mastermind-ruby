# Class for all things related to the board, playing the game, printing the clues, etc.
class Board
  attr_accessor :correct_place, :wrong_place
  attr_reader :code, :game_over

  def initialize(code = [1, 2, 3, 4, 5, 6])
    @code = [
      { number: code[0], guessed: false },
      { number: code[1], guessed: false },
      { number: code[2], guessed: false },
      { number: code[3], guessed: false }
    ]
    @correct_place = 0
    @wrong_place = 0
    @pegs = []
    @game_over = false
  end

  def choose_game_mode
    puts 'Please choose whether you\'d like to be the maker or the breaker of the code: '
    puts 'Press "1" for Maker, "2" for Breaker.'
    choice = gets.chomp
    until %w[1 2].include?(choice)
      puts 'Please enter a valid choice: '
      puts 'Press "1" for Maker, "2" for Breaker.'
      choice = gets.chomp
    end
    run_game_choice(choice)
  end

  def run_game_choice(choice)
    play_game_breaker(Breaker.new('User')) if choice == '2'
    play_game_maker(Maker.new('User')) if choice == '1'
  end

  def play_game_breaker(breaker)
    @code = Maker.generate_code(@code)
    puts @code
    play_round_breaker(breaker) until @game_over
  end

  def play_round_breaker(breaker)
    @code.each { |hash| hash[:guessed] = false }
    guesses = breaker.make_guesses
    check_guess(guesses)
    puts guesses.join(' ')
    if @game_over
      puts 'Congratulations! You\'ve broken the code.'
    else
      generate_pegs
      puts "Clues: #{@pegs.join(' ')}"
    end
  end

  def check_guess(guesses)
    reset_keys
    guesses.each_with_index do |value, index|
      if check_guess_for_place(value, index)
        @code[index][:guessed] = true
        @correct_place += 1
      elsif check_guess_for_value(value, guesses)
        @wrong_place += 1
      end
    end
    @game_over = true if @correct_place == 4
  end

  def check_guess_for_value(guess, guesses)
    @code.each_with_index do |value, index|
      return true if value[:number] == guess && value[:guessed] == false && value[:number] != guesses[index]
    end
    false
  end

  def check_guess_for_place(guess, index)
    guess == @code[index][:number]
  end

  protected

  def reset_keys
    @correct_place = 0
    @wrong_place = 0
  end

  def generate_pegs
    @pegs = []
    @correct_place.times { @pegs << '●' }
    @wrong_place.times { @pegs << '○' }
  end
end

# Class for making code, for both player and computer.
class Maker
  attr_reader :code, :board

  def initialize(name)
    @name = name
    @code = []
  end

  def set_code
    [nil, nil, nil, nil].each_with_index do |_value, index|
      puts "#{@name}, please enter your number for guess #{index + 1} in your code."
      @code[index] = gets.chomp.to_i
    end
  end

  def make_game_board
    @board = Board.new(@code)
  end

  def self.generate_code(board_code)
    possible_numbers = [1, 2, 3, 4, 5, 6]
    board_code.each { |hash| hash[:number] = possible_numbers.sample }
    board_code
  end
end

# Class for breaking the code, for both player and computer.
class Breaker
  attr_accessor :name, :number_of_guesses, :possible_numbers

  def initialize(name)
    @name = name
    @number_of_guesses = 0
    @possible_numbers = [1, 2, 3, 4, 5, 6]
  end

  def make_guesses
    guess_array = []
    [nil, nil, nil, nil].each_with_index do |value, index|
      puts "#{@name}, please enter your guess for spot number #{index + 1}."
      guess_array[index] = gets.chomp.to_i
      until valid_guess(guess_array[index])
        puts "Please enter a valid guess: #{@possible_numbers.join(', ')}."
        guess_array[index] = gets.chomp.to_i
      end
    end
    guess_array
  end

  def valid_guess(guess)
    guess.to_s.length == 1 && @possible_numbers.any? { |number| number == guess }
  end

  def computer_guess_code
    @possible_codes = make_possible_codes
    p @possible_codes.length
    until game_won
      guess = 1122
    end
  end

  def make_possible_codes
    [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a
  end
end

test = Board.new(['Y', 'R', 'G', 'R'])
keff = Breaker.new('keff')

keff.computer_guess_code

test.choose_game_mode