class Movement
  def initialize(board=nil)
    @board = board
  end

  def horizontal_move(cell)
    result = []
    col_chrs = ('a'..'h').to_a
    piece, file, rank =  cell.content, cell.coordinate[0], cell.coordinate[1]
    file_index = col_chrs.index(file)
    offset = piece_offset(piece, 'h') 

    (-offset..offset).each do |i|
      next if i == 0
      new_file_index = file_index + i
      next unless new_file_index.between?(0, 7)

      target_cell = @board.cell("#{col_chrs[new_file_index]}#{rank}")
      result << target_cell.to_s if target_cell && (target_cell.empty? || target_cell.capture?(piece))
    end
    result.sort
  end

  private

  def piece_offset(piece, direction)
    offsets = {
      'r' => { 'h' => 7, 'v' => 7, 'd' => nil, 'c' => nil },
      'q' => { 'h' => 7, 'v' => 7, 'd' => 7, 'c' => nil },
      'p' => { 'h' => nil, 'v' => 1, 'd' => 1, 'c' => nil },
      'b' => { 'h' => nil, 'v' => nil, 'd' => 7, 'c' => nil },
      'k' => { 'h' => 1, 'v' => 1, 'd' => 1, 'c' => nil },
      'n' => { 'h' => nil, 'v' => nil, 'd' => nil, 'c' => [2, 1] }
    }
    offsets[piece.downcase][direction]
  end
end
