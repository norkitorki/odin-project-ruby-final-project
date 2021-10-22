# frozen-string-literal: true

class ChessPiece
  attr_reader :symbol, :position, :file, :rank

  def initialize(symbol)
    @symbol = symbol
  end
end
