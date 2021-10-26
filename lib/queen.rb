# frozen-string-literal: true

require_relative 'chess_piece'

# Queen Chess Piece Class
class Queen < ChessPiece
  def moveset
    return [] unless position

    right_up + right + right_down + down + left_down + left + left_up + up
  end
end
