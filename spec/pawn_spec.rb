# frozen-string-literal: true

require_relative '../lib/pawn'

describe Pawn do
  subject(:pawn) { described_class.new(unicode_pawn) }
  let(:unicode_pawn) { '🨾' }

  describe '#moveset' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(pawn.moveset).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid move from coordinate C3' do
        position = 'C3'
        pawn.position = position
        moves = %w[C4]
        expect(pawn.moveset).to match_array(moves)
      end

      context 'when the pawn is placed at its initial position' do
        it 'should return the next valid moves from coordinate F2' do
          position = 'F2'
          pawn.position = position
          moves = %w[F3 F4]
          expect(pawn.moveset).to match_array(moves)
        end
      end

      it 'should return an empty array when there is no valid move' do
        position = 'H8'
        pawn.position = position
        moves = []
        expect(pawn.moveset).to match_array(moves)
      end
    end
  end
end
