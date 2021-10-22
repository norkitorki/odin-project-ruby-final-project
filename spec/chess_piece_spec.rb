# frozen-string-literal: true

require_relative '../lib/chess_piece'

describe ChessPiece do
  subject(:chess_piece) { ChessPiece.new(unicode_queen) }
  let(:unicode_queen) { '🨁' }
end
