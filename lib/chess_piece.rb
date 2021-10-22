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

  def valid_coordinate?(coordinate)
    coordinate.to_s[/^[a-hA-H][1-8]$/] != nil
  end
end
