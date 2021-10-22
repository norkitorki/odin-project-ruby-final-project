# frozen-string-literal: true

# Parent class for chess pieces
class ChessPiece
  attr_reader :symbol, :position, :file, :rank

  def initialize(symbol)
    @symbol = symbol
  end
end
