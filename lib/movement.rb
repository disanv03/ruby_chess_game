class Movement
  def initialize(board=nil)
    @board = board
  end

  def horizontal_move(starting_cell)
    result = []
    col_chrs = ('a'..'h').to_a
    piece, file, rank =  starting_cell.content, starting_cell.coordinate[0], starting_cell.coordinate[1]
    file_index = col_chrs.index(file)
    offset = piece_offset(piece, 'h') 

    add_moves_in_direction = lambda do |direction|
        (1..offset).each do |i|
        new_file_index = file_index + i * direction
        break unless new_file_index.between?(0, 7)

        target_cell = @board.cell("#{col_chrs[new_file_index]}#{rank}")
        if target_cell.empty?
          result << target_cell.to_s
        elsif target_cell.capture?(piece)
          result << targe_cell.to_s
          break
        else
          # case when we got a friendly piece
          break
        end
      end
    end
    
    add_moves_in_direction.call(-1) #left
    add_moves_in_direction.call(1) # right

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
