class Movement
  def initialize(board=nil)
    @board = board
  end
   
  # horizontal_move: finding legal horizontal moves
  def horizontal_move(starting_cell, board = @board)
    directions = [-1, 1]
    offset = piece_offset(starting_cell.content, 'h')
    move_in_directions(starting_cell, directions, offset, :horizontal, board)
  end

  # vertical_move: from a cell, it found the legal vertical move of that piece
  def vertical_move(starting_cell, board = @board)
    directions = [-1, 1]
    offset = piece_offset(starting_cell.content, 'v')
    move_in_directions(starting_cell, directions, offset, :vertical, board)
  end

  # diagonal_move: find all legal diagonal moves
  def diagonal_move(starting_cell, board = @board)
    directions = [[-1, -1], [-1, 1], [1, -1], [1, 1]] # UL, UR, DL, DR
    offset = piece_offset(starting_cell.content, 'd')
    move_in_directions(starting_cell, directions, offset, :diagonal, board)
  end

  # find_king_moves: give all legals king move
  # Protected opponent pieces need to become capture impossible
  def find_king_moves(starting_cell, board = @board)
    piece = starting_cell.content
    return nil unless piece == 'K' || piece == 'k'

    # 1- King potential moves
    vcal = vertical_move(starting_cell)
    htal = horizontal_move(starting_cell)
    dnal = diagonal_move(starting_cell)
    
    puts "Debug: vertical moves: #{vcal}"
    puts "Debug: horizontal moves: #{htal}"
    puts "Debug: diagonal moves: #{dnal}"

    # 2- Oponnent's threats
    opp_color = starting_cell.opponent_color
    opp_threats = threats_map(board, opp_color)

    puts "Debug: Opponent's threats: #{opp_threats}"

    # 3- Filter
    # here forward pawn move count as a threat move
    potential_moves = ((vcal + htal + dnal).uniq - opp_threats).sort
    stripped_moves = strip_x_from_moves(potential_moves)

    puts "Debug: Potential moves after threat removal: #{potential_moves}"
    puts "Debug: Stripped moves: #{stripped_moves}"

    # 4- Second Filter for capture that would put the king in check
    # On an transition_board, make the king  move on each potential_moves 
    # then apply is_in_check? to discard illegal moves
    legal_moves = stripped_moves.select do |move|
      transition_board = board.deep_dup
      transition_board.make_move(starting_cell.coordinate, move)

      in_check = is_in_check?(transition_board, move)
      puts "Debug: checking move #{move}: in_check = #{in_check}"

      !in_check
    end
    
    puts "Debug: legal moves: #{legal_moves.sort}"
    legal_moves.sort
  end

  # find_knight_moves: giving all knight move and capture prefixed by 'x'
  def find_knight_moves(starting_cell, board = @board)
    start = board.std_chess_to_arr(starting_cell.coordinate)
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

      next_ref = board.arr_to_std_chess(new_pos)
      step = board.cell(next_ref)

      if (step)
        capture = step.capture?(piece) ? 'x' : ''
        result << (capture + step.to_s) if step.empty? || step.capture?(piece)
      end
    end
    result.sort
  end

  # find_pawn_moves: direction is different depending on colors.
  # Also give the correct starting point.
  def find_pawn_moves(starting_cell, board = @board)
    return nil unless %w[p P].include?(starting_cell.content)
    direction_from_color = (starting_cell.content == 'P' ? -1 : 1)
    home_rank = starting_cell.content == 'P' ? 6 : 1
    compute_pawn_moves(starting_cell, direction_from_color, home_rank, board)
  end

  # find_queen_moves: combine all directions do get the complete
  # available list of Queen moves.
  def find_queen_moves(starting_cell, board = @board)
    piece = starting_cell.content
    return nil unless piece == 'Q' || piece == 'q'

    vcal = vertical_move(starting_cell, board)
    htal = horizontal_move(starting_cell, board)
    dnal = diagonal_move(starting_cell, board)

    (vcal + htal + dnal).sort
  end

  # find_moves: orienting toward the correct function moves
  def find_moves(starting_cell, board = @board)
    return nil if starting_cell.empty?

    case starting_cell.content
    when 'p', 'P'
      find_pawn_moves(starting_cell, board)
    when 'n', 'N'
      find_knight_moves(starting_cell, board)
    when 'k', 'K'
      find_king_moves(starting_cell, board)
    when 'b', 'B'
      diagonal_move(starting_cell, board)
    when 'r', 'R'
      htal = horizontal_move(starting_cell, board)
      vcal = vertical_move(starting_cell, board)
      (htal + vcal).sort
    else
      find_queen_moves(starting_cell, board)
    end
  end

  private
  # move_in_directions: depending on the given type direction it find the correct moves
  def move_in_directions(starting_cell, directions, offset, type, board)
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
          target_cell = board.board[rank_number][new_file_index]
        elsif type == :vertical
          new_rank_index = rank_number + i * direction
          break unless new_rank_index.between?(0, 7)
          target_cell = board.board[new_rank_index][file_index]
        elsif type == :diagonal
          new_rank_index = rank_number + i * direction[0]
          new_file_index = file_index + i * direction[1]
          break unless new_rank_index.between?(0, 7) && new_file_index.between?(0, 7)
          target_cell = board.board[new_rank_index][new_file_index]
        end

        if target_cell.empty?
          result << target_cell.to_s
        elsif target_cell.capture?(piece)
          result << ('x'+target_cell.to_s)
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
  def compute_pawn_moves(starting_cell, direction, home_rank, board = @board)
    start = board.std_chess_to_arr(starting_cell.coordinate)
    double_fwd = start[0] == home_rank
    result = []
    
    # simple forward and double forward offsets
    next_refs = double_fwd ? [[start[0] + direction, start[1]], [start[0] + (direction * 2), start[1]]] : [[start[0] + direction, start[1]]]
    next_refs.each do |arr_moves|
      next if arr_moves.any?(&:negative?) || arr_moves.any? { |x| x > 7 }
      next_ref = board.get_square(arr_moves)
      result << next_ref.to_s if next_ref.empty?
      break unless next_ref.empty?
    end

    # simple captures, if opponent piece stand on his forward diagonal
    next_refs = [[start[0] + direction, start[1] - 1], [start[0] + direction, start[1] + 1]]
    next_refs.each do |arr_moves|
      next if arr_moves.any?(&:negative?) || arr_moves.any? { |x| x > 7 }
      next_ref = board.get_square(arr_moves)
      capture = next_ref.capture?(starting_cell.content) ? 'x' : ''
      result << (capture + next_ref.to_s) if !next_ref.empty? && next_ref.capture?(starting_cell.content)
    end

    # en passant capture available ?
    # comming soon...

    result.sort
  end

  # threats_map: looping the board and identify all opponent's threats
  def threats_map(board_instance, opp_color)
    threats = []
    board_instance.board.each_with_index do |x, y|
      x.each_with_index do |cell, x|
        next if cell.empty? || cell.color != opp_color
        piece_threats = find_moves(cell)
        threats.concat(piece_threats)
      end
    end
    threats.uniq
  end

  def is_in_check?(board, king_cell)
    king = board.cell(king_cell)
    return nil unless king.content == 'K' || king.content == 'k'

    opp_color = king.opponent_color
    opp_threats = threats_map(board, opp_color)
    opp_threats_stripped = strip_x_from_moves(opp_threats)
    puts "Debug: King position #{king_cell}, opponent threats: #{opp_threats_stripped}"
    opp_threats_stripped.include?(king_cell)
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

  # strip_x_from_moves: given a array of moves, strip any 'x' occurence in a move
  def strip_x_from_moves(moves)
    moves.map { |move| move.delete('x') }
  end

end
