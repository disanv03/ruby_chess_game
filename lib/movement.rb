class Movement
  def initialize(board=nil)
    @board = board
  end

  def horizontal_move(cell)
    result = []
    piece = cell.content.downcase
    coord = cell.coordinate.chars
    rank = coord[1]
    col_x = coord[0].ord
    offset = piece == 'k' ? 1 : 7
   
    (1..offset).each do |i|
      right = col_x + i
      left = col_x - i
      result << "#{right.chr}#{rank}" if ('a'.ord..'h'.ord).include?(right)
      result << "#{left.chr}#{rank}" if ('a'.ord..'h'.ord).include?(left)
    end
    result.sort
  end
end
