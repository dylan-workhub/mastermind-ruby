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
    @game_over = false
    puts 'The colours available to choose are (Y)ellow, (R)ed, (G)reen, (B)lue, (P)urple, and (O)range.'
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
      puts 'Congratulations! You\'ve guessed the code.'
    else
      puts "correct places: #{@correct_place}"
      puts "wrong places but right colour: #{@wrong_place}"
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
  attr_accessor :name, :number_of_guesses

  def initialize(name)
    @name = name
    @number_of_guesses = 0
  end

  def make_guesses
    guess_array = []
    [nil, nil, nil, nil].each_with_index do |value, index|
      puts "#{@name}, please enter your guess for spot number #{index + 1}."
      guess_array[index] = gets.chomp.upcase
    end
    guess_array
  end
end

test = Board.new(['Y', 'R', 'G', 'R'])
keff = Breaker.new('keff')

test.play_game_breaker(keff)
