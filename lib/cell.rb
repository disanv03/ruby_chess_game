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

end

