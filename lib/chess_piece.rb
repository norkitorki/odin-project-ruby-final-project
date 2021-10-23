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
      puts "#{coordinate} is not a valid chess coordinate."
    end
  end

  # to_vector('D4') => [3, 3]
  def to_vector(coordinate)
    return nil unless valid_coordinate?(coordinate)

    [coordinate[1].to_i - 1, coordinate[0].downcase.ord - 97]
  end

  # to_coordinate([3, 3]) => 'D4'
  def to_coordinate(vector)
    return nil unless valid_vector?(vector)

    "#{('A'..'H').to_a[vector[0]]}#{vector[1] + 1}"
  end

  def valid_coordinate?(coordinate)
    coordinate.to_s[/^[a-hA-H][1-8]$/] != nil
  end

  def valid_vector?(vector)
    vector.is_a?(Array) && vector.length == 2 &&
      vector.all? { |e| e.is_a?(Integer) && e.between?(0, 7) }
  end
end
