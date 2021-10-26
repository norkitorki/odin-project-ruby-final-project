# frozen-string-literal: true

require_relative 'chess_piece'

# King Chess Piece Class
class King < ChessPiece
  def moveset
    return [] unless position

    right_up + right + right_down + down + left_down + left + left_up + up
  end

  def right_up
    super(1)
  end

  def right
    super(1)
  end

  def right_down
    super(1)
  end

  def down
    super(1)
  end

  def left_down
    super(1)
  end

  def left
    super(1)
  end

  def left_up
    super(1)
  end

  def up
    super(1)
  end
end

KING = King.new('X')
KING.position = 'B2'
p KING.right_up
