# frozen-string-literal: true

require_relative 'chess_piece'

# Bishop Chess Piece Class
class Bishop < ChessPiece
  def left_down
    return [] unless position

    l_rank = rank.to_i
    moves = []
    ('A'...file).to_a.reverse.each { |file| l_rank <= 1 ? break : moves << "#{file}#{l_rank -= 1}" }
    moves
  end

  def left_up
    return [] unless position

    l_rank = rank.to_i
    moves = []
    ('A'...file).to_a.reverse.each { |file| l_rank >= 8 ? break : moves << "#{file}#{l_rank += 1}" }
    moves
  end
end
