require_relative 'cell'

class Board
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
      rank.each_char do |piece|
        case piece
        when /^[rnbqkp]$/i
          @board[rank_index][col_index] = Cell.new(piece, "#{col[col_index]}#{8 - rank_index}")
          col_index += 1
        when /^[1-8]$/
          digit = piece.to_i
          digit.times do
            @board[rank_index][col_index] = Cell.new(nil, "#{col[col_index]}#{8 - rank_index}")
            col_index += 1
          end
        else
          raise ArgumentError, "Unexpected character in piece notation: #{piece}"
        end
     end
      rank_index += 1
    end
  end

end

