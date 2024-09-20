class Cell
  attr_reader :content, :coordinate

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
end

