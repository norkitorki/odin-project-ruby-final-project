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
  end
end
