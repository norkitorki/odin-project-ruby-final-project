# frozen-string-literal: true

# chess castling functionality
module Castleable
  def castleable?(player_pieces, opponent_pieces, rook_position)
    return false unless king?

    rook = find_rook(player_pieces, rook_position)
    king_checked = positions_checked?(player_pieces, opponent_pieces, [position])
    return false unless rook && !king_checked

    valid_castling?(player_pieces, opponent_pieces, rook, castle_coordinates(rook))
  end

  def castle_moveset(player_pieces, opponent_pieces)
    return [] unless king?

    moves = []
    moves << castling.first if castleable?(player_pieces, opponent_pieces, "A#{rank}")
    moves << castling.last if castleable?(player_pieces, opponent_pieces, "H#{rank}")
    moves
  end

  def castle(player_pieces, destination)
    return unless king?

    update_position(destination)
    rook = find_rook(player_pieces, destination == castling.first ? "A#{rank}" : "H#{rank}")
    rook.update_position(rook_destination(position))
  end

  def castling?(position)
    king? && !moved? && castling.any?(position)
  end

  private

  def king?
    type == :king
  end

  def find_king(player_pieces)
    player_pieces.find { |p| p.type == :king }
  end

  def find_rook(player_pieces, position)
    player_pieces.find { |p| p.type == :rook && p.position == position }
  end

  def castle_coordinates(rook)
    rook.file == 'A' ? ["C#{rank}", "D#{rank}"] : ["F#{rank}", "G#{rank}"]
  end

  def rook_destination(king_position)
    king_position == castling.first ? "D#{rank}" : "F#{rank}"
  end

  def castling
    ["C#{rank}", "G#{rank}"]
  end

  def valid_castling?(player_pieces, opponent_pieces, rook, traversal)
    piece_positions = (player_pieces + opponent_pieces).map(&:position)

    !moved? && !rook.moved? && squares_empty?(piece_positions, traversal) &&
      !positions_checked?(player_pieces, opponent_pieces, traversal)
  end

  def squares_empty?(piece_positions, traversal)
    traversal.none? { |pos| piece_positions.any?(pos) }
  end

  def positions_checked?(player_pieces, opponent_pieces, positions)
    opponent_pieces.any? do |p|
      next if p.type == :king

      p.moveset(opponent_pieces, player_pieces).any? { |pos| positions.any?(pos) }
    end
  end
end
