# frozen-string-literal: true

require_relative 'chess_piece'

# Rook Chess Piece Class
class Rook < ChessPiece
  def moveset
    return [] unless position

    right_moves + down_moves + left_moves + up_moves
  end

  def right_moves
    (file.next..'H').map { |file| ["#{file}#{rank}"] }
  end

  def down_moves
    (rank.to_i - 1).downto(1).map { |rank| ["#{file}#{rank}"] }
  end

  def left_moves
    ('A'...file).to_a.reverse.map { |file| ["#{file}#{rank}"] }
  end

  def up_moves
    (rank.to_i + 1).upto(8).map { |rank| ["#{file}#{rank}"] }
  end
end
