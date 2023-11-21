class Movement
  def initialize(board=nil)
    @board = board
  end

  def horizontal_move(cell)
    result = []
    col_chars = ('a'..'h').to_a
    piece = cell.content.downcase
    coord = cell.coordinate.chars
    rank = coord[1]
    col_x = coord[0].ord - 'a'.ord
    offset = nil

    case piece
    when 'r', 'q'
      offset = 7
    when 'k'
      offset = 1
    end

    (1..offset).to_a.each do |i|
      right = col_x + i
      left = col_x - i
      result << "#{col_chars[right]}#{rank}" if (0..7).include?(right)
      result << "#{col_chars[left]}#{rank}" if (0..7).include?(left)
    end
    result.sort
  end
end
