# frozen-string-literal: true

require_relative 'chess_piece'

# Queen Chess Piece Class
class Queen < ChessPiece
  def right_up
    return [] unless position

    r_rank = rank.to_i
    moves = []
    (file.next..'H').each { |file, i| r_rank >= 8 ? break : moves << "#{file}#{r_rank += 1}" }
    moves
  end

  def right
    position ? (file.next..'H').map { |file| "#{file}#{rank.to_i}" } : []
  end

  def right_down
    return [] unless position

    r_rank = rank.to_i
    moves = []
    (file.next..'H').each { |file| r_rank <= 1 ? break : moves << "#{file}#{r_rank -= 1}" }
    moves
  end

  def down
    position ? (rank.to_i - 1).downto(1).map { |rank| "#{file}#{rank}" } : []
  end
end
