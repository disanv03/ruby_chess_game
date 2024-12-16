require_relative 'cell'

class Board
  attr_accessor :board
  
  def initialize()
    @board = Array.new(8) { Array.new(8, nil) }
    @active = nil
    @castle = nil
    @passant = nil
    @half = nil
    @full = nil
  end
  
  # make_move: effeciently change the content of origin&destination cells
  def make_move(origin, destination)
    from = cell(origin)
    to = cell(destination)

    to.content = from.content.dup
    from.content = nil
  end

  # make_board: parse a fen to a Board, setting up each cell using chess notation
  def make_board(fen='rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    pieces, @active, @castle, @passant, @half, @full = fen.split(' ')
    pieces = pieces.split('/')
    @half = @half.to_i
    @full = @full.to_i

    col = ('a'..'h').to_a
    rank_index = 0 
    pieces.each do |rank|
      col_index = 0
      rank.each_char do |piece_or_digit|
        case piece_or_digit
        when /[rnbqkp]/i
          piece = piece_or_digit
          @board[rank_index][col_index] = Cell.new(piece, "#{col[col_index]}#{8 - rank_index}")
          col_index += 1
        when /[1-8]/
          digit = piece_or_digit.to_i
          digit.times do
            @board[rank_index][col_index] = Cell.new(nil, "#{col[col_index]}#{8 - rank_index}")
            col_index += 1
          end
        else
          raise ArgumentError, "Unexpected character in piece notation: #{piece_or_digit}"
        end
     end
      rank_index += 1
    end
  end

  # make_fen: gather components to form the complete FEN string
  def make_fen
    [board_to_fen, @active, @castle, @passant, @half, @full].join(' ')
  end

  # arr_to_std_chess: converts computer notation to std chess
  def arr_to_std_chess(arr)
    return nil unless arr.join =~ /^[0-7]{2}$/
    letter = (arr[1] + 'a'.ord).chr
    num = 8 - arr[0]
    "#{letter}#{num}"
  end

  # std_chess_to_arr:  converts std chess to computer array like notation
  def std_chess_to_arr(coordinate)
    return nil unless coordinate =~ /^[a-h][1-8]$/
      x = coordinate[0].ord - 'a'.ord
      y = 8 - coordinate[1].to_i
      [y, x]
  end

  # cell: finding the adequate Cell on the board from a std chess notation
  def cell(coordinate)
    arr = std_chess_to_arr(coordinate)
    @board[arr[0]][arr[1]]
  end

  # get_square: getting from array notation the corresponding Cell
  def get_square(arr)
    @board[arr[0]][arr[1]]
  end

  # deep_dup: making a deep copy of the board to ensure that each
  # move simulation operates on an independant board state
  def deep_dup
    new_board = Board.new

    new_board.board = @board.map do |y|
      y.map do |x_cell|
        x_cell.deep_dup
      end
    end
    new_board
  end

  private

  # board_to_fen: making a FEN from the current board
  # An empty cell, return 1, the chunk loop sum consecutive empty cell.
  def board_to_fen
    str = []
    @board.each.with_index(1) do |x_elements, y|
      x_elements.each { |square| str << square.to_fen }
      str << '/' unless y == x_elements.length
    end
    parsed = []
    str.chunk { |el| el == '1' }.each do |is_one, chunk|
      parsed << (is_one ? chunk.sum(&:to_i) : chunk.join)
    end
    parsed.join
  end
    
end

