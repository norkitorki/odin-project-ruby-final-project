# frozen-string-literal: true

# chess player for a chess game
class ChessPlayer
  attr_reader :pawn, :rook, :knight, :bishop, :queen, :king, :captures
  attr_accessor :name

  PIECES = %i[@pawn @rook @knight @bishop @queen @king @captures].freeze

  def initialize(name)
    @name = name
    reset
  end

  def add_piece(piece)
    send(piece.type) << piece if PIECES.any?("@#{piece.type}".to_sym)
  end

  def remove_piece(position)
    piece = find_piece_by(:position, position)
    return unless piece

    send(piece.type).delete_if { |p| p.position == position }
    piece
  end

  def pieces(attribute = nil)
    pieces = (pawn + rook + knight + bishop + queen + king)
    if attribute
      pieces.map! { |p| p.send(attribute) if p.respond_to?(attribute) }.compact!
    end
    pieces
  end

  def reset
    PIECES.each { |var| instance_variable_set(var, []) }
  end

  def find_piece_by(attribute, value, pieces = self.pieces)
    pieces.find { |p| p.send(attribute) == value if p.respond_to?(attribute) }
  end

  def capture(piece)
    captures << piece
  end

  def piece?(attribute, value)
    find_piece_by(attribute, value) != nil
  end

  def capture?(attribute, value)
    find_piece_by(attribute, value, captures) != nil
  end
end
