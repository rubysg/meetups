# require "minitest/autorun"
# require "pry"

class Node
  attr_accessor :value, :left, :right, :top,
                :bottom, :top_right, :bottom_right,
                :top_left, :bottom_left

  def initialize
    @value, @left, @right, @top, @bottom, @top_right, @bottom_right, @top_left, @bottom_left = nil
  end
end

class Reversi
  attr_accessor :board

  WIDTH = 10
  HEIGHT = 10

  def initialize
    initialize_board

    @board.each_with_index do |row, h|
      row.each_with_index do |node, w|
        case
        when h == 0 && w == 0
          node.right = @board[h][w+1]
          node.bottom = @board[h+1][w]
          node.bottom_right = @board[h+1][w+1]
        when h == 0 && w == WIDTH - 1
          node.left = @board[h][w-1]
          node.bottom = @board[h+1][w]
          node.bottom_left = @board[h+1][w-1]
        when h == HEIGHT - 1 && WIDTH == 0
          node.right = @board[h][w+1]
          node.top = @board[h-1][w]
          node.top_right = @board[h-1][w+1]
        when h == HEIGHT - 1 && WIDTH == WIDTH - 1
          node.left = @board[h][w-1]
          node.top = @board[h-1][w]
          node.top_left = @board[h-1][w-1]
        when h == 0
          node.left = @board[h][w-1]
          node.right = @board[h][w+1]
          node.bottom = @board[h+1][w]
          node.bottom_right = @board[h+1][w+1]
          node.bottom_left = @board[h+1][w-1]
        when h == HEIGHT - 1
          node.left = @board[h][w-1]
          node.right = @board[h][w+1]
          node.top = @board[h-1][w]
          node.top_right = @board[h-1][w+1]
          node.top_left = @board[h-1][w-1]
        when w == 0
          node.right = @board[h][w+1]
          node.top = @board[h-1][w]
          node.bottom = @board[h+1][w]
          node.top_right = @board[h-1][w+1]
          node.bottom_right = @board[h+1][w+1]
        when w == WIDTH - 1
          node.left = @board[h][w-1]
          node.top = @board[h-1][w]
          node.bottom = @board[h+1][w]
          node.top_left = @board[h-1][w-1]
          node.bottom_left = @board[h+1][w-1]
        else
          node.left = @board[h][w-1]
          node.right = @board[h][w+1]
          node.top = @board[h-1][w]
          node.bottom = @board[h+1][w]
          node.top_right = @board[h-1][w+1]
          node.top_left = @board[h-1][w-1]
          node.bottom_right = @board[h+1][w+1]
          node.bottom_left = @board[h+1][w-1]
        end
      end
    end
  end

  def initialize_board
    @board = []

    HEIGHT.times do
      row = []
      WIDTH.times do
        node = Node.new
        row << node
      end

      @board << row
    end
  end

  def play(player, x, y)
    token = player ? 0 : 1

    played_node = @board[y][x]
    return false if played_node.value
    played_node.value = token

    flip_in_direction(played_node, :top)
    flip_in_direction(played_node, :bottom)
    flip_in_direction(played_node, :right)
    flip_in_direction(played_node, :left)
    flip_in_direction(played_node, :top_right)
    flip_in_direction(played_node, :top_left)
    flip_in_direction(played_node, :bottom_right)
    flip_in_direction(played_node, :bottom_left)

    true
  end

  def flip_in_direction(played_node, direction)
    nodes = []

    next_node = played_node.send(direction)
    found = false
    while !found
      break if next_node == nil
      break if next_node.value == nil
      if next_node.value == played_node.value
        found = true
        break
      end
      nodes << next_node
      next_node = next_node.send(direction)
    end

    if found
      nodes.each { |n| n.value = played_node.value }
    end
  end

  def print
    @board.map do |row|
      row.map do |node|
        if node.value == 0
          "O"
        elsif node.value == 1
          'X'
        else
          '-'
        end
      end
    end
  end
end

class CLI
  def initialize
    @reversi = Reversi.new
  end

  def start
    puts <<~INSTRUCTIONS

      $$$ R-E-V-E-R-S-I $$$
      Welcome to the game!

      Inputs:
        Make a move       -> x-coordinate y-coordinate
        Exit the game     -> exit
        Restart the game  -> restart

    INSTRUCTIONS

    player = true

    while true
      print_board

      print "#{ player ? "P1" : "P2"}> "
      input = gets.chomp.downcase

      case input
      when "exit"
        puts "Hope to see you again!"
        break
      when "restart" || "r"
        @reversi = Reversi.new
        player = true
      else
        coor = input.split(" ")
        if coor.length != 2
          puts "Invalid Input"
          next
        end

        x = Integer(coor[0]) rescue nil
        y = Integer(coor[1]) rescue nil
        if x && y
          if @reversi.play(player, x, y)
            player = !player
          else
            puts "Spot is taken"
            next
          end
        else
          puts "Invalid Input"
          next
        end
      end
    end
  end

  def print_board
    result = @reversi.print
    result.each do |row|
      p row
    end
    puts "^^^^^^^^^^^^^^^^^^"
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