# frozen-string-literal: true

# handling initial chess piece setup
module PiecesSetup
  INITIAL_COORDINATES = {
    pawn: %w[A2 B2 C2 D2 E2 F2 G2 H2],
    rook: %w[A1 H1],
    knight: %w[B1 G1],
    bishop: %w[C1 F1],
    queen: %w[D1],
    king: %w[E1]
  }.freeze

  def setup_pieces(player, pieces, color = :white)
    INITIAL_COORDINATES.each do |type, coordinates|
      coordinates.each do |pos|
        pos = "#{pos[0]}#{9 - pos[1].to_i}" unless color == :white
        player.add_piece(new(type, pos, pieces[type], color: color))
      end
    end
  end
end
