# frozen-string-literal: true

require_relative '../lib/queen'

describe Queen do
  subject(:queen) { described_class.new(unicode_queen) }
  let(:unicode_queen) { '🨁' }

  describe '#moveset' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(queen.moveset).to eq(empty_array)
      end
    end

    context 'when a position is assigned' do
      it 'should return the next valid moves from coordinate E4' do
        position = 'E4'
        queen.position = position
        moves = %w[F5 G6 H7 F4 G4 H4 F3 G2 H1 E3 E2 E1 D3 C2 B1 D4 C4 B4 A4 D5 C6 B7 A8 E5 E6 E7 E8]
        expect(knight.moveset).to match_array(moves)
      end

      it 'should return the next valid moves from coordinate A7' do
        position = 'A7'
        knight.position = position
        moves = %w[B8 B7 C7 D7 E7 F7 G7 H7 B6 C5 D4 E3 F2 G1 A6 A5 A4 A3 A2 A1 A8]
        expect(knight.moveset).to match_array(moves)
      end

      it 'should return the next valid moves from coordinate H5' do
        position = 'H5'
        knight.position = position
        moves = %w[H4 H3 H2 H1 G4 F3 E2 D1 G5 F5 E5 D5 C5 B5 A5 G6 F7 E8 H6 H7 H8]
        expect(knight.moveset).to match_array(moves)
      end
    end
  end

  describe '#right_up' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(queen.right_up).to eq(empty_array)
      end
    end

    context 'when a position is asigned' do
      it 'should return the next valid moves from the right up from C2' do
        position = 'C2'
        queen.position = position
        moves = %w[D3 E4 F5 G6 H7]
        expect(queen.right_up).to eq(moves)
      end
    end

    it 'should return an empty array when there are no valid moves' do
      position = 'F8'
      queen.position = position
      moves = []
      expect(queen.right_up).to eq(moves)
    end
  end

  describe '#right' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(queen.right).to eq(empty_array)
      end
    end

    context 'when a position is asigned' do
      it 'should return the next valid moves to the right of B7' do
        position = 'B7'
        queen.position = position
        moves = %w[C7 D7 E7 F7 G7 H7]
        expect(queen.right).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'H2'
        queen.position = position
        moves = []
        expect(queen.right).to eq(moves)
      end
    end
  end

  describe '#right_down' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(queen.right_down).to eq(empty_array)
      end
    end

    context 'when a position is asigned' do
      it 'should return the next valid moves from the right down from A5' do
        position = 'A5'
        queen.position = position
        moves = %w[B4 C3 D2 E1]
        expect(queen.right_down).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'E1'
        queen.position = position
        moves = []
        expect(queen.right_down).to eq(moves)
      end
    end
  end

  describe '#down' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(queen.down).to eq(empty_array)
      end
    end

    context 'when a position is asigned' do
      it 'should return the next valid moves down from F7' do
        position = 'F7'
        queen.position = position
        moves = %w[F6 F5 F4 F3 F2 F1]
        expect(queen.down).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'D1'
        queen.position = position
        moves = []
        expect(queen.down).to eq(moves)
      end
    end
  end

  describe '#left_down' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(queen.left_down).to eq(empty_array)
      end
    end

    context 'when a position is asigned' do
      it 'should return the next valid moves from the left down from G6' do
        position = 'G6'
        queen.position = position
        moves = %w[F5 E4 D3 C2 B1]
        expect(queen.left_down).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'A4'
        queen.position = position
        moves = []
        expect(queen.left_down).to eq(moves)
      end
    end
  end

  describe '#left' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(queen.left).to eq(empty_array)
      end
    end

    context 'when a position is asigned' do
      it 'should return the next valid moves to the left of H2' do
        position = 'H2'
        queen.position = position
        moves = %w[G2 F2 E2 D2 C2 B2 A2]
        expect(queen.left).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'A6'
        queen.position = position
        moves = []
        expect(queen.left).to eq(moves)
      end
    end
  end

  describe '#left_up' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(queen.left_up).to eq(empty_array)
      end
    end

    context 'when a position is asigned' do
      it 'should return the next valid moves from the left up from F1' do
        position = 'F1'
        queen.position = position
        moves = %w[E2 D3 C4 B5 A6]
        expect(queen.left_up).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'A6'
        queen.position = position
        moves = []
        expect(queen.left_up).to eq(moves)
      end
    end
  end

  describe '#up' do
    context 'when position is nil' do
      it 'should return an empty array' do
        empty_array = []
        expect(queen.up).to eq(empty_array)
      end
    end

    context 'when a position is asigned' do
      it 'should return the next valid moves up from D2' do
        position = 'D2'
        queen.position = position
        moves = %w[D3 D4 D5 D6 D7 D8]
        expect(queen.up).to eq(moves)
      end

      it 'should return an empty array when there are no valid moves' do
        position = 'E8'
        queen.position = position
        moves = []
        expect(queen.up).to eq(moves)
      end
    end
  end
end
