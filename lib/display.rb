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

  def show_board(board = @board, moves: [])
    puts "\n"
    cell_counter = 0
    board.board.each do |y|
      y.each do |cell|
        if moves.include?(cell.coordinate) && cell.empty?
          print colorize_background(" \u2022 ", cell_counter.even?) # unicode for •
        elsif moves.include?(cell.coordinate) && !cell.empty?
          print colorize_background_for_capture(" #{PIECE_LOOKUP[cell.to_display]} ")
        else
          print colorize_background(" #{PIECE_LOOKUP[cell.to_display]} ", cell_counter.even?)
        end
        cell_counter += 1
      end
      puts
      cell_counter += 1
    end
    puts "\n"
  end

  def colorize_background(text, white)
    # dark brown for black, light brown for white
    # \e[48;5;94m dark brown
    # \e[48;5;137m lighter brown
    background_code = white ? "\e[48;5;137m" : "\e[48;5;94m"
    "#{background_code}#{text}\e[0m"
  end

  def colorize_background_for_capture(text)
    "\e[48;5;160m#{text}\e[0m"
  end

end
