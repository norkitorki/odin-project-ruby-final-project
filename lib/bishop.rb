# frozen-string-literal: true

require_relative 'chess_piece'

# Bishop Chess Piece Class
class Bishop < ChessPiece
  def moveset
    return [] unless position

    left_down + left_up + right_down + right_up
  end
end
