# frozen-string-literal: true

# handling of check and checkmate
module Checkable
  def check?(player_pieces, opponent_pieces)
    king_position = player_pieces.find { |piece| piece.type == :king }.position
    opponent_pieces.any? do |piece|
      piece.moveset(opponent_pieces, player_pieces).any?(king_position)
    end
  end

  def checkmate?(player_pieces, opponent_pieces)
    check?(player_pieces, opponent_pieces) && player_pieces.none? do |piece|
      piece.moveset(player_pieces, opponent_pieces).any? do |pos|
        piece.legal_move?(player_pieces, opponent_pieces, pos)
      end
    end
  end

  def legal_move?(player_pieces, opponent_pieces, destination)
    !checked_at_position?(player_pieces, opponent_pieces, self, destination)
  end

  private

  def checked_at_position?(player_pieces, opponent_pieces, piece, position)
    op_piece = opponent_pieces.find { |p| p.position == position }
    opponent_pieces.delete(op_piece)
    initial_position = piece.position
    piece.update_position(position, piece_moved: false)
    check = check?(player_pieces, opponent_pieces)
    piece.update_position(initial_position, piece_moved: false)
    opponent_pieces << op_piece if op_piece
    check
  end
end
