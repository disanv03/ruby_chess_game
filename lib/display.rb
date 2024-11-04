class Display
  PIECE_LOOKUP = {
    'P' => "\u265F", # '♟'
    'R' => "\u265C", # '♜'
    'N' => "\u265E", # '♞'
    'B' => "\u265D", # '♝'
    'Q' => "\u265B", # '♛'
    'K' => "\u265A", # '♚'
    'p' => "\u2659", # '♙'
    'r' => "\u2656", # '♖'
    'n' => "\u2658", # '♘'
    'b' => "\u2657", # '♗'
    'q' => "\u2655", # '♕'
    'k' => "\u2654", # '♔'
    ' ' => ' '
  }.freeze

  def initialize(board = nil)
    @board = board
  end

  def show_board(board = @board)
    cell_counter = 0
    board.board.each do |y|
      y.each do |cell|
        print colorize_background(" #{PIECE_LOOKUP[cell.to_display]} ", cell_counter.even?)
        cell_counter += 1
      end
      puts
      cell_counter += 1
    end
  end

  def colorize_background(text, white)
    # dark brown for black, light brown for white
    # \e[48;5;94m dark brown
    # \e[48;5;137m lighter brown
    background_code = white ? "\e[48;5;137m" : "\e[48;5;94m"
    "#{background_code}#{text}\e[0m"
  end

end
