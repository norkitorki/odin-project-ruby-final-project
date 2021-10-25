# frozen-string-literal: true

require_relative '../lib/king'

describe King do
  subject(:king) { described_class.new(unicode_king) }
  let(:unicode_king) { '🨀' }

  describe '#moveset' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(king.moveset).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves from coordinate E2' do
        position = 'E2'
        king.position = position
        moves = %w[F3 F2 F1 E1 D1 D2 D3 E3]
        expect(king.moveset).to match_array(moves)
      end

      it 'should return the next valid moves from coordinate F1' do
        position = 'F1'
        king.position = position
        moves = %w[G2 G1 E1 E2 F2]
        expect(king.moveset).to match_array(moves)
      end

      it 'should return the next valid moves from coordinate H4' do
        position = 'H4'
        king.position = position
        moves = %w[H3 G3 G4 G5 H5]
        expect(king.moveset).to match_array(moves)
      end
    end
  end

  describe '#right_up' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(king.right_up).to eq(empty_array)
      end
    end

    context 'when a position is asigned' do
      it 'should return the next valid move from the right up from G1' do
        position = 'G1'
        king.position = position
        moves = %w[H2]
        expect(king.right_up).to eq(moves)
      end
    end

    it 'should return an empty array when there are no valid moves' do
      position = 'H2'
      king.position = position
      moves = []
      expect(king.right_up).to eq(moves)
    end
  end
end
