class Cell
  attr_reader :content, :coordinate

  def initialize(piece=nil, coordinate=nil)
    @content = piece
    @coordinate = coordinate
  end

  def empty?
    @content.nil?
  end
end

