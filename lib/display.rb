class Display
  PIECE_LOOKUP = {
    'P' => '♟',
    'R' => '♜',
    'N' => '♞',
    'B' => '♝',
    'Q' => '♛',
    'K' => '♚',
    'p' => '♙',
    'r' => '♖',
    'n' => '♘',
    'b' => '♗',
    'q' => '♕',
    'k' => '♔',
    ' ' => ' '
  }.freeze

  def initialize(board = nil)
    @board = board
  end

  def show_board(board = @board)
    cell_counter = 0
    board.board.each do |y|
      y.each do |cell|
        print colorize_background(" #{PIECE_LOOKUP[cell.to_display]} ", cell_counter.odd?)
        cell_counter += 1
      end
      puts
      cell_counter += 1
    end
  end

  def colorize_background(text, alternate = false)
    # dark brown for black, light brown for white
    # \e[48;5;94m dark brown
    # \e[48;5;137m lighter brown
    background_code = alternate ? "\e[48;5;94m" : "\e[48;5;137m" 
    "#{background_code}#{text}\e[0m"
  end

end
