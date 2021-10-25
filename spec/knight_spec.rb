# frozen-string-literal: true

require_relative '../lib/knight'

describe Knight do
  subject(:knight) { described_class.new(unicode_knight) }
  let(:unicode_knight) { '🩒' }

  describe '#moveset' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(knight.moveset).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves from coordinate D4' do
        position = 'D4'
        knight.position = position
        moves = %w[B3 B5 C2 C6 E2 E6 F3 F5]
        expect(knight.moveset).to match_array(moves)
      end

      it 'should return the next valid moves from coordinate A6' do
        position = 'A6'
        knight.position = position
        moves = %w[B4 B8 C5 C7]
        expect(knight.moveset).to match_array(moves)
      end

      it 'should return the next valid moves from coordinate H7' do
        position = 'H7'
        knight.position = position
        moves = %w[G5 F6 F8]
        expect(knight.moveset).to match_array(moves)
      end
    end
  end
end
