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

  def make_board(fen='rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    parts = fen.split(' ')
    pieces = parts[0].split('/')
    @active = parts[1]
    @castle = parts[2]
    @passant = parts[3]
    @half = parts[4].to_i
    @full = parts[5].to_i

    col = ('a'..'h').to_a
    rank_index = 0 # upgrade the rank number coordinate
    pieces.each do |rank|
      col_index = 0
      rank.each_char do |piece_or_digit|
        case piece_or_digit
        when /^[rnbqkp]$/i
          piece = piece_or_digit
          @board[rank_index][col_index] = Cell.new(piece, "#{col[col_index]}#{8 - rank_index}")
          col_index += 1
        when /^[1-8]$/
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

  def make_fen
    [board_to_fen, @active, @castle, @passant, @half, @full].join(' ')
  end

  def arr_to_std_chess(input)
    return nil unless input.join =~ /^[0-7]{2}$/
    letter = (input[1] + 'a'.ord).chr
    num = 8 - input[0]
    "#{letter}#{num}"
  end

  def std_chess_to_arr(input)
    return nil unless input =~ /^[a-h][1-8]$/
      x = input[0].ord - 'a'.ord
      y = 8 - input[1].to_i
      [y, x]
  end

  def cell(input)
    coords = std_chess_to_arr(input)
    @board[coords[0]][coords[1]]
  end

  private

  def board_to_fen
    str = []
    @board.each.with_index(1) do |rank, index|
      rank.each { |cell| str << cell.to_fen }
      str << '/' unless index == rank.length
    end
    parsed = []
    str.chunk { |el| el == '1' }.each do |is_one, chunk|
      parsed << (is_one ? chunk.sum(&:to_i) : chunk.join)
    end
    parsed.join
  end
    
end

