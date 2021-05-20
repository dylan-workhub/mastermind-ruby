class Board
  attr_accessor :correct_place, :wrong_place
  attr_reader :code, :game_over

  def initialize(code)
    @code = code
    @correct_place = 0
    @wrong_place = 0
    @game_over = false
    puts 'The colours available to choose are (Y)ellow, (R)ed, (G)reen, (B)lue, (P)urple, and (O)range.'
  end

  def play_game_breaker(breaker)
    play_round_breaker(breaker) until @game_over
  end

  def play_round_breaker(breaker)
    guesses = breaker.make_guesses
    check_guess(guesses)
    puts guesses.join(' ')
    if @game_over
      puts 'Congratulations! You\'ve guessed the code.'
    else
      puts "correct places: #{@correct_place}"
      puts "wrong places but right number: #{@wrong_place}"
    end
  end

  def check_guess(guesses)
    reset_keys
    guesses.each_with_index do |value, index|
      if check_guess_for_place(value, index)
        @correct_place += 1
      elsif check_guess_for_value(value)
        @wrong_place += 1
      end
    end
    if @correct_place == 4
      @game_over = true
    end
  end

  def check_guess_for_value(guess)
    @code.any? { |code_colour| code_colour == guess }
  end

  def check_guess_for_place(guess, index)
    guess == @code[index]
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
