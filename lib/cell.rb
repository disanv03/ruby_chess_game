class Cell
  attr_reader :content, :name

  def initialize(piece=nil, name=nil)
    @content = piece
    @name = name
  end

  def empty?
    @content.nil?
  end
end

