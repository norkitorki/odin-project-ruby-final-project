# frozen-string-literal: true

require_relative 'chess_piece'

# Knight Chess Piece Class
class Knight < ChessPiece
  MOVES = [
    [-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]
  ].freeze

  def moveset
    return [] unless position

    pos_vector = to_vector(position)
    move_set = []
    MOVES.each do |x, y|
      vector = to_coordinate([x + pos_vector[0], y + pos_vector[1]])
      move_set << vector if vector
    end
    move_set
  end
end
