# frozen-string-literal: true

# Parent class for chess pieces
class ChessPiece
  attr_reader :symbol, :position, :file, :rank

  def initialize(symbol)
    @symbol = symbol
  end

  def position=(coordinate)
    if valid_coordinate?(coordinate)
      @file = coordinate[0]
      @rank = coordinate[1]
      @position = coordinate
    else
      puts 'Invalid coordinate'
    end
  end
end
