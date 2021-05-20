class Board
  attr_accessor :correct_place, :wrong_place
  attr_reader :code

  def initialize(code)
    @code = code
    @correct_place = 0
    @wrong_place = 0
    puts 'The colours available to choose are (Y)ellow, (R)ed, (G)reen, (B)lue, (P)urple, and (O)range.'
  end

  def check_guess(guess)
    reset_keys
    guess.each_with_index do |value, index|
      if check_guess_for_place(value, index)
        @correct_place += 1
      elsif check_guess_for_value(value)
        @wrong_place += 1
      else
        next
      end
    end
    puts @correct_place
    puts @wrong_place
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
    [nil, nil, nil, nil].each_with_index do |value, index|
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

test = Board.new(['Y', 'R', 'G', 'B'])

test.check_guess(['Y', 'R', 'Y', 'B'])