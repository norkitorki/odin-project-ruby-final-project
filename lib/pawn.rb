# frozen-string-literal: true

require_relative 'chess_piece'

# Pawn Chess Piece Class
class Pawn < ChessPiece
  def moveset
    return [] unless position

    position[1] == '2' ? up(2) : up(1)
  end

  def diagonal_up
    return [] unless position

    left_up(1) + right_up(1)
  end
end
