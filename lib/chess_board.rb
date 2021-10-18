# frozen-string-literal: false

# Chess Board Class
class ChessBoard
  attr_reader :fields

  def initialize
    @fields = Array.new(8) { Array.new(8) }
  end
end
