class Movement
  def initialize(board=nil)
    @board = board
  end
  
  # horizontal_move: finding legal horizontal moves
  def horizontal_move(starting_cell)
    directions = [-1, 1]
    offset = piece_offset(starting_cell.content, 'h')
    move_in_directions(starting_cell, directions, offset, :horizontal)
  end

  # vertical_move: from a cell, it found the legal vertical move of that piece
  def vertical_move(starting_cell)
    directions = [-1, 1]
    offset = piece_offset(starting_cell.content, 'v')
    move_in_directions(starting_cell, directions, offset, :vertical)
  end

  # diagonal_move: find all legal diagonal moves
  def diagonal_move(starting_cell)
    # [-1, -1] UP-LEFT
    # [-1, 1] UP-RIGHT
    # [1, -1] DOWN-LEFT
    # [1, 1] DOWN-RIGHT
    directions = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    offset = piece_offset(starting_cell.content, 'd')
    move_in_directions(starting_cell, directions, offset, :diagonal)
  end

  # find_knight_moves: giving all knight move and capture prefixed by 'x'
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

      if (step)
        capture = step.capture?(piece) ? 'x' : ''
        result << (capture + step.to_s) if step.empty? || step.capture?(piece)
      end
    end
    result.sort
  end

  # find_pawn_moves: moves are different depending of the pawn colors.
  # This function pass the correct direction and the starting rank (home_rank)
  # to the compute_pawn_moves function
  def find_pawn_moves(starting_cell)
    return nil unless %w[p P].include?(starting_cell.content)
    direction_from_color = (starting_cell.content == 'P' ? -1 : 1)
    home_rank = starting_cell.content == 'P' ? 6 : 1
    compute_pawn_moves(starting_cell, direction_from_color, home_rank)
  end

  private
  # move_in_directions: depending on the given type direction it find the correct moves
  def move_in_directions(starting_cell, directions, offset, type)
    result = []
    col_chrs = ('a'..'h').to_a
    piece, file, rank = starting_cell.content, starting_cell.coordinate[0], starting_cell.coordinate[1].to_i
    file_index = col_chrs.index(file)
    rank_number = 8 - rank

    directions.each do |direction|
      (1..offset).each do |i|
        if type == :horizontal
          new_file_index = file_index + i * direction
          break unless new_file_index.between?(0, 7)
          target_cell = @board.board[rank_number][new_file_index]
        elsif type == :vertical
          new_rank_index = rank_number + i * direction
          break unless new_rank_index.between?(0, 7)
          target_cell = @board.board[new_rank_index][file_index]
        elsif type == :diagonal
          new_rank_index = rank_number + i * direction[0]
          new_file_index = file_index + i * direction[1]
          break unless new_rank_index.between?(0, 7) && new_file_index.between?(0, 7)
          target_cell = @board.board[new_rank_index][new_file_index]
        end

        if target_cell.empty?
          result << target_cell.to_s
        elsif target_cell.capture?(piece)
          result << target_cell.to_s
          break
        else
          # friendly piece
          break
        end
      end
    end
    result.sort
  end

  # compute_pawn_moves: listing correct pawn moves, including
  # simple forward, double forward, simple captures (and en passant capture)
  def compute_pawn_moves(starting_cell, direction, home_rank)
    start = @board.std_chess_to_arr(starting_cell.coordinate)
    double_fwd = start[0] == home_rank
    result = []
    
    # simple forward and double forward offsets
    next_refs = double_fwd ? [[start[0] + direction, start[1]], [start[0] + (direction * 2), start[1]]] : [[start[0] + direction, start[1]]]
    next_refs.each do |arr_moves|
      next if arr_moves.any?(&:negative?) || arr_moves.any? { |x| x > 7 }
      next_ref = @board.get_square(arr_moves)
      result << next_ref.to_s if next_ref.empty?
      break unless next_ref.empty?
    end

    # simple captures, if opponent piece stand on his forward diagonal
    next_refs = [[start[0] + direction, start[1] - 1], [start[0] + direction, start[1] + 1]]
    next_refs.each do |arr_moves|
      next if arr_moves.any?(&:negative?) || arr_moves.any? { |x| x > 7 }
      next_ref = @board.get_square(arr_moves)
      capture = next_ref.capture?(starting_cell.content) ? 'x' : ''
      result << (capture + next_ref.to_s) if !next_ref.empty? && next_ref.capture?(starting_cell.content)
    end

    result.sort
  end


  # piece_offset: returns the right offset number for a given piece
  def piece_offset(piece, direction)
    offsets = {
      'r' => { 'h' => 7, 'v' => 7, 'd' => 0 },
      'q' => { 'h' => 7, 'v' => 7, 'd' => 7 },
      'p' => { 'h' => 0, 'v' => 1, 'd' => 1 },
      'b' => { 'h' => 0, 'v' => 0, 'd' => 7 },
      'k' => { 'h' => 1, 'v' => 1, 'd' => 1 }
    }
    offsets[piece.downcase][direction]
  end

end
