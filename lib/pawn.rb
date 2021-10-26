# frozen-string-literal: true

require_relative 'chess_piece'

# Pawn Chess Piece Class
class Pawn < ChessPiece
  def moveset
    return [] unless position

    position[1] == '2' ? up(2) : up(1)
  end
end
