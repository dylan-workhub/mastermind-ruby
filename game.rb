class Board
  def initialize(code)
    @code = code
  end

  def print_game_board

  end

  def check_guess_for_value(guess)
    guess.reduce(0) do |sum, value|
      if colour_in_code?(value)
        sum += 1
      end
      sum
    end
  end

  def colour_in_code?(guess_colour)
    @code.any? { |code_colour| code_colour == guess_colour }
  end

  def check_guess_for_place(guess)
    index = 0
    guess.reduce(0) do |sum, value|
      if value == @code[index]
        sum += 1
      end
      index += 1
      sum
    end
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
puts test.check_guess_for_value(['Y', 'G', 'R', 'X'])
puts test.check_guess_for_place(['Y', 'R', 'Y', 'B'])