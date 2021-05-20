# require "minitest/autorun" # Uncomment to run test

class Reversi
  WIDTH = 10
  HEIGHT = 10

  attr_reader :board

  def initialize
    @board = nil
  end

  def play(player, x, y)
  end

  def print
  end
end

class CLI
  def initialize
    @reversi = Reversi.new
  end

  def start
    puts "Welcome to the game!"
    player = true

    while true
      print_board
      print "#{ player ? "P1" : "P2"}> "
      input = gets.chomp.downcase

      case input
      when "exit"
        puts "Hope to see you again!"
        break
      when "restart"
        @reversi = Reversi.new
        player = true
      else
        coor = input.split(" ")
        x = coor[0].to_i
        y = coor[1].to_i

        @reversi.play(player, x, y)
        player = !player
      end
    end
  end

  def print_board
    # TODO: Print board
  end
end

CLI.new.start

# class ReversiTest < Minitest::Test
#   def setup
#     @reversi = Reversi.new
#   end

#   def test_fail
#     assert false
#   end
# end