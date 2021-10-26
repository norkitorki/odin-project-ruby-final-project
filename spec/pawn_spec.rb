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

  describe '#diagonal_up' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(pawn.diagonal_up).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves from coordinate D3' do
        position = 'D3'
        pawn.position = position
        moves = %w[C4 E4]
        expect(pawn.diagonal_up).to eq(moves)
      end

      it 'should return the next valid move from coordinate A4' do
        position = 'A4'
        pawn.position = position
        moves = %w[B5]
        expect(pawn.diagonal_up).to eq(moves)
      end

      it 'should return the next valid move from coordinate H3' do
        position = 'H3'
        pawn.position = position
        moves = %w[G4]
        expect(pawn.diagonal_up).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'E8'
        pawn.position = position
        moves = %w[]
        expect(pawn.diagonal_up).to eq(moves)
      end
    end
  end
end
