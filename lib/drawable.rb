# frozen-string-literal: true

# draw conditions for chess game
module Drawable
  def stalemate?(player_pieces, opponent_pieces)
    king = player_pieces.find { |p| p.type == :king }
    return false if king.check?(player_pieces, opponent_pieces)

    player_pieces.all? do |piece|
      piece.moveset(player_pieces, opponent_pieces).none? do |pos|
        piece.legal_move?(player_pieces, opponent_pieces, pos)
      end
    end
  end

  def dead_position?(player_pieces, opponent_pieces)
    player_types = convert_to_types(player_pieces)
    opponent_types = convert_to_types(opponent_pieces)
    king_against_king?(player_types, opponent_types) ||
      king_against_king_and_bishop?(player_types, opponent_types) ||
      king_against_king_and_knight?(player_types, opponent_types)
  end

  private

  def convert_to_types(pieces)
    pieces.map(&:type)
  end

  def king_against_king?(player_types, opponent_types)
    (player_types + opponent_types).all?(:king)
  end

  def king_against_king_and_bishop?(player_types, opponent_types)
    player_types == %i[king] && opponent_types.sort == %i[bishop king]
  end

  def king_against_king_and_knight?(player_types, opponent_types)
    player_types == %i[king] && opponent_types.sort == %i[king knight]
  end
end
