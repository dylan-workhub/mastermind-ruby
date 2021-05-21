class Board
  attr_accessor :correct_place, :wrong_place
  attr_reader :code, :game_over

  def initialize(code = %w[Y R G R])
    @code = [
      { colour: code[0], guessed: false },
      { colour: code[1], guessed: false },
      { colour: code[2], guessed: false },
      { colour: code[3], guessed: false }
    ]
    @correct_place = 0
    @wrong_place = 0
    @pegs = []
    @game_over = false
    puts 'The colours available to choose are (Y)ellow, (R)ed, (G)reen, (B)lue, (P)urple, and (O)range.'
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
      return true if value[:colour] == guess && value[:guessed] == false && value[:colour] != guesses[index]
    end
    false
  end

  def check_guess_for_place(guess, index)
    guess == @code[index][:colour]
  end

  def generate_pegs
    @pegs = []
    @correct_place.times { @pegs << '●' }
    @wrong_place.times { @pegs << '○' }
  end

  protected

  def reset_keys
    @correct_place = 0
    @wrong_place = 0
  end
end

class Maker
  attr_reader :code, :board

  def initialize(name)
    @name = name
    @code = []
  end

  def set_code
    [nil, nil, nil, nil].each_with_index do |_value, index|
      puts "#{@name}, please enter your colour for number #{index + 1} in your code."
      @code[index] = gets.chomp.upcase
    end
  end

  def make_game_board
    @board = Board.new(@code)
  end

  def self.generate_code(board_code)
    puts board_code.join(' ')
    possible_colours = %w[Y R G B P O]
    board_code.each { |hash| hash[:colour] = possible_colours.sample }
    puts board_code
    board_code
  end
end

class Breaker
  attr_accessor :name, :number_of_guesses, :possible_colours

  def initialize(name)
    @name = name
    @number_of_guesses = 0
    @possible_colours = %w[Y R G B P O]
  end

  def make_guesses
    guess_array = []
    [nil, nil, nil, nil].each_with_index do |value, index|
      puts "#{@name}, please enter your guess for spot number #{index + 1}."
      guess_array[index] = gets.chomp.upcase
      until valid_guess(guess_array[index])
        puts "Please enter a valid guess: #{@possible_colours.join(', ')}."
        guess_array[index] = gets.chomp.upcase
      end
    end
    guess_array
  end

  def valid_guess(guess)
    guess.length == 1 && @possible_colours.any? { |colour| colour == guess }
  end
end

test = Board.new(['Y', 'R', 'G', 'R'])
keff = Breaker.new('keff')

test.choose_game_mode