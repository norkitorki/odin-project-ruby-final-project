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
end
