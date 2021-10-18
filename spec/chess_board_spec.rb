# frozen-string-literal: true

require_relative '../lib/chess_board'

describe ChessBoard do
  subject(:chess_board) { described_class.new }

  describe '#to_s' do
    context 'when fields are empty' do
      it 'should print the empty board' do
        expect(chess_board.to_s).to eq(
          <<~BOARD
            ┏━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┓
          8 ┃   │   │   │   │   │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          7 ┃   │   │   │   │   │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          6 ┃   │   │   │   │   │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          5 ┃   │   │   │   │   │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          4 ┃   │   │   │   │   │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          3 ┃   │   │   │   │   │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          2 ┃   │   │   │   │   │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          1 ┃   │   │   │   │   │   │   │   ┃
            ┗━━━┷━━━┷━━━┷━━━┷━━━┷━━━┷━━━┷━━━┛
              A   B   C   D   E   F   G   H
          BOARD
        )
      end
    end
  end

  describe '#place' do
    context 'when the field is empty' do
      it 'should place a symbol on the board' do
        position = 'D5'
        symbol = '🨁'
        chess_board.place(position, symbol)
        expect(chess_board.fields[4][3]).to eq(symbol)
      end
    end

    context 'when the field is not empty' do
      before { chess_board.fields[6][5] = 'X' }

      it 'should not place a symbol on the board' do
        position = 'F7'
        new_symbol = '🨁'
        placed_symbol = chess_board.fields[6][5]
        chess_board.place(position, new_symbol)
        expect(chess_board.fields[6][5]).to eq(placed_symbol)
      end
    end

    context 'when the position is invalid' do
      it 'should not change the fields' do
        position = 'B20'
        symbol = '🩒'
        expect { chess_board.place(position, symbol) }.not_to change { chess_board.fields }
      end

      it 'should not raise an exception' do
        position = 'A-4'
        symbol = '🩏'
        expect { chess_board.place(position, symbol) }.not_to raise_exception
      end
    end
  end
end
