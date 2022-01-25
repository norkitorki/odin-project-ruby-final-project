# frozen-string-literal: true

require_relative 'chess_player'

# basic chess computer
class ChessComputer < ChessPlayer
  def initialize(name = 'Computer')
    super(name)
  end

  def move(opponent_pieces)
    capture_move(opponent_pieces) ||
      checked_move(opponent_pieces) ||
      defensive_move(opponent_pieces) ||
      safe_move(opponent_pieces) ||
      random_move(opponent_pieces)
  end

  def checked_move(opponent_pieces)
    if king.first.check?(pieces, opponent_pieces)
      (king + pieces).each do |c_piece|
        moveset = c_piece.moveset(pieces, opponent_pieces).shuffle
        dest = moveset.find { |pos| legal_move?(c_piece, opponent_pieces, pos) }
        return { piece: c_piece, destination: dest } if dest
      end
    end
    nil
  end

  def capture_move(opponent_pieces)
    opponent_pieces.reverse!
    pieces.each do |c_piece|
      c_piece.moveset(pieces, opponent_pieces).each do |pos|
        piece = opponent_pieces.find { |o_piece| pos == o_piece.position }
        legal_move = piece && legal_move?(c_piece, opponent_pieces, pos)
        return { piece: c_piece, destination: pos } if legal_move
      end
    end
    nil
  end

  def defensive_move(opponent_pieces)
    opponent_moves = opponent_moves(opponent_pieces)
    pieces.reverse.each do |c_piece|
      moveset = c_piece.moveset(pieces, opponent_pieces).shuffle
      next if moveset.empty? || opponent_moves.none?(c_piece.position)

      dest = moveset.find { |pos| opponent_moves.none?(pos) }
      legal_move = dest && legal_move?(c_piece, opponent_pieces, dest)
      return { piece: c_piece, destination: dest } if legal_move
    end
    nil
  end

  def safe_move(opponent_pieces)
    opponent_moves = opponent_moves(opponent_pieces)
    pieces.shuffle.each do |c_piece|
      moveset = c_piece.moveset(pieces, opponent_pieces).shuffle
      next if moveset.empty?

      dest = moveset.find { |pos| opponent_moves.none?(pos) }
      legal_move = dest && legal_move?(c_piece, opponent_pieces, dest)
      return { piece: c_piece, destination: dest } if legal_move
    end
    nil
  end

  def random_move(opponent_pieces)
    pieces.shuffle.each do |c_piece|
      dest = c_piece.moveset(pieces, opponent_pieces).sample
      legal_move = dest && legal_move?(c_piece, opponent_pieces, dest)
      return { piece: c_piece, destination: dest } if legal_move
    end
    nil
  end

  private

  def opponent_moves(opponent_pieces)
    opponent_pieces.map { |p| p.moveset(opponent_pieces, pieces) }.flatten
  end

  def legal_move?(piece, opponent_pieces, destination)
    return true unless piece.respond_to?(:legal_move?)

    piece.legal_move?(pieces, opponent_pieces, destination)
  end
end
