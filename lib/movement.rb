class Movement
  def initialize(board=nil)
    @board = board
  end

  # TODO:
  # horizontal and vertical moves almost the same
  # try to make it one method call moves doing both horizontal/vertical adding
  # depending of the offset of the current piece
  #
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
          result << target_cell.to_s
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

  def vertical_move(starting_cell)
    result = []
    col_chrs = ('a'..'h').to_a
    piece, file, rank =  starting_cell.content, starting_cell.coordinate[0], starting_cell.coordinate[1].to_i
    file_index = col_chrs.index(file)
    rank_number = 8 - rank
    offset = piece_offset(piece, 'v') 

    add_moves_in_direction = lambda do |direction|
      (1..offset).each do |i|
        new_rank_index = rank_number + i * direction
        break unless new_rank_index.between?(0, 7)
        target_cell = @board.board[new_rank_index][file_index]
        if target_cell.empty?
          result << target_cell.to_s
        elsif target_cell.capture?(piece)
          result << target_cell.to_s
          break
        else
          # case we got a friendly piece
          break
        end
    end
  end
    add_moves_in_direction.call(-1)
    add_moves_in_direction.call(1)

    result.sort
  end

  def diagonal_move(starting_cell)
    result = []
    col_chrs = ('a'..'h').to_a
    piece, file, rank =  starting_cell.content, starting_cell.coordinate[0], starting_cell.coordinate[1].to_i
    file_index = col_chrs.index(file)
    rank_number = 8 - rank
    offset = piece_offset(piece, 'd') 

    add_moves_in_direction = lambda do |rank_dir, file_dir|
      (1..offset).each do |i|
        new_rank_index = rank_number + i * rank_dir
        new_file_index = file_index + i * file_dir

        break unless new_rank_index.between?(0, 7) && new_file_index.between?(0,7)

        target_cell = @board.board[new_rank_index][new_file_index]
        if target_cell.empty?
          result << target_cell.to_s
        elsif target_cell.capture?(piece)
          result << target_cell.to_s
          break
        else
          # case we got a friendly piece
        break
          end
        end
    end
    add_moves_in_direction.call(-1, -1) # UP-LEFT
    add_moves_in_direction.call(-1, 1) # UP-RIGHT
    add_moves_in_direction.call(1, -1) # DOWN-LEFT
    add_moves_in_direction.call(1, 1) # DOWN-RIGHT

    result.sort
  end

  def find_knight_moves(starting_cell)
    start = @board.std_chess_to_arr(starting_cell.coordinate)
    piece = starting_cell.content
    return nil unless piece == 'N' || piece == 'n'

    moves = [
      [2, 1], [2, -1], [-2, 1], [-2, -1],
      [1, 2], [1, -2], [-1, 2], [-1, -2]
    ]

    result = []
    moves.each do |move|
      new_pos =  [start[0] + move[0], start[1] + move[1]]
      next if new_pos.any? { |coord| coord < 0 || coord >= 8 }

      next_ref = @board.arr_to_std_chess(new_pos)
      step = @board.cell(next_ref)

      if step
        capture = step.capture?(piece) ? 'x' : ''
        result << (capture + step.to_s) if step.empty? || step.capture?(piece)
      end
    end
    result.sort
  end
                                

  private
  def piece_offset(piece, direction)
    offsets = {
      'r' => { 'h' => 7, 'v' => 7, 'd' => 0 },
      'q' => { 'h' => 7, 'v' => 7, 'd' => 7 },
      'p' => { 'h' => 0, 'v' => 1, 'd' => 1 },
      'b' => { 'h' => 0, 'v' => 0, 'd' => 7 },
      'k' => { 'h' => 1, 'v' => 1, 'd' => 1 },
      'n' => { 'h' => 0, 'v' => 0, 'd' => 0 }
    }
    offsets[piece.downcase][direction]
  end

end
