# frozen-string-literal: true

require_relative 'chess_piece'

# Rook Chess Piece Class
class Rook < ChessPiece
  def moveset
    return [] unless position

    right + down + left + up
  end
end
