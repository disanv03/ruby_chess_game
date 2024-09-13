class Cell
  attr_reader :content, :coordinate

  def initialize(piece=nil, coordinate=nil)
    @content = piece
    @coordinate = coordinate
  end

  def empty?
    @content.nil?
  end

  def to_fen
    @content.nil? ? '1' : @content
  end

  def to_s
    @coordinate
  end

  def capture?(attacking)
    return false if @content.nil?
    attacking_color = attacking.ord < 91 ? 'w' : 'b'
    piece_color = @content.ord < 91 ? 'w' : 'b'
    attacking_color != piece_color
  end
end

