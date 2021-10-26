# frozen-string-literal: true

require_relative 'chess_piece'

# Queen Chess Piece Class
class Queen < ChessPiece
  def moveset
    return [] unless position

    right_up + right + right_down + down + left_down + left + left_up + up
  end

  def right_up
    return [] unless position

    r_rank = rank.to_i
    moves = []
    (file.next..'H').each { |file| r_rank >= 8 ? break : moves << "#{file}#{r_rank += 1}" }
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

  def left_down
    return [] unless position

    l_rank = rank.to_i
    moves = []
    ('A'...file).to_a.reverse.each { |file| l_rank <= 1 ? break : moves << "#{file}#{l_rank -= 1}" }
    moves
  end

  def left
    position ? ('A'...file).to_a.reverse.map { |file| "#{file}#{rank}" } : []
  end

  def left_up
    return [] unless position

    l_rank = rank.to_i
    moves = []
    ('A'...file).to_a.reverse.each { |file| l_rank >= 8 ? break : moves << "#{file}#{l_rank += 1}" }
    moves
  end

  def up
    position ? (rank.to_i + 1).upto(8).map { |rank| "#{file}#{rank}" } : []
  end
end
