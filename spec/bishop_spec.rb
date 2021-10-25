# frozen-string-literal: true

require_relative '../lib/bishop'

describe Bishop do
  subject(:bishop) { described_class.new(unicode_bishop) }
  let(:unicode_bishop) { '🨃' }

  describe '#left_down' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(bishop.left_down).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves from the left down from H5' do
        position = 'H5'
        bishop.position = position
        moves = %w[G4 F3 E2 D1]
        expect(bishop.left_down).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'H1'
        bishop.position = position
        moves = []
        expect(bishop.left_down).to eq(moves)
      end
    end
  end

  describe '#left_up' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(bishop.left_up).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves from the left up from G4' do
        position = 'G4'
        bishop.position = position
        moves = %w[F5 E6 D7 C8]
        expect(bishop.left_up).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'C8'
        bishop.position = position
        moves = []
        expect(bishop.left_up).to eq(moves)
      end
    end
  end

  describe '#right_down' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(bishop.right_down).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves from the right down from C8' do
        position = 'C8'
        bishop.position = position
        moves = %w[D7 E6 F5 G4 H3]
        expect(bishop.right_down).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'H5'
        bishop.position = position
        moves = []
        expect(bishop.right_down).to eq(moves)
      end
    end
  end

  describe '#right_up' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(bishop.right_up).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves from the right down from A3' do
        position = 'A3'
        bishop.position = position
        moves = %w[B4 C5 D6 E7 F8]
        expect(bishop.right_up).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'D8'
        bishop.position = position
        moves = []
        expect(bishop.right_up).to eq(moves)
      end
    end
  end
end
