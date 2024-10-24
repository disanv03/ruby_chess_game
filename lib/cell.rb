class Cell
  attr_accessor :content
  attr_accessor :coordinate

  def initialize(piece=nil, coordinate=nil)
    @content = piece
    @coordinate = coordinate
  end

  # check if there is a piece on the cell
  def empty?
    @content.nil?
  end

  # to_s: give the coordinate of the cell
  def to_s
    @coordinate
  end

  # to_fen: give the content of the cell
  # '1' for empty cell else piece character
  def to_fen
    @content.nil? ? '1' : @content
  end

  # to_display: helper for printing the board on the terminal
  def to_display
    @content.nil? ? ' ' : @content
  end

  # capture?: check if capture is allowed
  # the method is better read from right to left giving:
  # does the argument can capture the calling cell content.
  # White use uppercase letter < 91 as "Z" is 90
  # Black use lowercase starting from 97 = "a"
  def capture?(attacking)
    return false if @content.nil?
    attacking_color = attacking.ord < 91 ? 'w' : 'b'
    target_color = @content.ord < 91 ? 'w' : 'b'
    attacking_color != target_color
  end

  # color: give the corresponding char color of the calling cell
  def color
    @content.ord < 91 ? 'w' : 'b'
  end

  # opponent_color: give the opponent_color of the calling cell
  def opponent_color
    @content.ord < 91 ? 'b' : 'w'
  end

  # deep_dup: ensure that each cell is independently duplicated
  def deep_dup
    new_cell = Cell.new
    new_cell.content = @content.nil? ? nil : @content.dup
    new_cell.coordinate = @coordinate.dup
    new_cell
  end
end

