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

    context 'when some fields are occupied' do
      before { 8.times { |i| chess_board.fields[i][i] = 'X' } }

      it 'should print the board' do
        expect(chess_board.to_s).to eq(
          <<~BOARD
            ┏━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┓
          8 ┃   │   │   │   │   │   │   │ X ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          7 ┃   │   │   │   │   │   │ X │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          6 ┃   │   │   │   │   │ X │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          5 ┃   │   │   │   │ X │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          4 ┃   │   │   │ X │   │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          3 ┃   │   │ X │   │   │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          2 ┃   │ X │   │   │   │   │   │   ┃
            ┠───┼───┼───┼───┼───┼───┼───┼───┨
          1 ┃ X │   │   │   │   │   │   │   ┃
            ┗━━━┷━━━┷━━━┷━━━┷━━━┷━━━┷━━━┷━━━┛
              A   B   C   D   E   F   G   H
          BOARD
        )
      end
    end
  end

  describe '#place' do
    context 'when the coordinates are valid' do
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
    end

    context 'when the coordinates are invalid' do
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

    context 'when the symbol length is invalid' do
      it 'should not change the fields' do
        position = 'C1'
        symbol = 'xYx'
        expect { chess_board.place(position, symbol) }.not_to change { chess_board.fields }
      end
    end
  end

  describe '#at' do
    context 'when the coordinates are valid' do
      before do
        coordinates = 'B6'
        symbol = '🨂'
        chess_board.place('B6', symbol)
      end

      context 'when the field is empty' do
        it "should return ' '" do
          coordinates = 'B4'
          empty_field = ' '
          expect(chess_board.at(coordinates)).to eq(empty_field)
        end
      end

      context 'when the field is not empty' do
        it 'should return the symbol placed at the field' do
          coordinates = 'B6'
          expected_symbol = '🨂'
          expect(chess_board.at(coordinates)).to eq(expected_symbol)
        end
      end
    end

    context 'when the coordinates are out of range' do
      it 'should return nil' do
        coordinates = 'B500'
        expect(chess_board.at(coordinates)).to be_nil
      end
    end
  end

  describe '#field_empty?' do
    context 'when the field at the given coordinates is empty' do
      it 'should return true' do
        coordinates = 'D3'
        expect(chess_board.field_empty?(coordinates)).to eq(true)
      end
    end

    context 'when the field at the given coordinates is not empty' do
      before do
        coordinates = 'A5'
        symbol = '🨾'
        chess_board.place(coordinates, symbol)
      end

      it 'should return false' do
        coordinates = 'A5'
        expect(chess_board.field_empty?(coordinates)).to eq(false)
      end
    end
  end

  describe '#valid_coordinate?' do
    context 'when the coordinates are valid' do
      it 'should return true when coordinates are passed as a symbol' do
        coordinates = :F8
        expect(chess_board.valid_coordinate?(coordinates)).to eq(true)
      end

      it 'should return true when coordinates are passed as a string' do
        coordinates = 'F4'
        expect(chess_board.valid_coordinate?(coordinates)).to eq(true)
      end
    end

    context 'when coordinates are invalid' do
      context 'when coordinates are out of range' do
        it 'should return false' do
          coordinates = 'C14'
          expect(chess_board.valid_coordinate?(coordinates)).to eq(false)
        end
      end

      context 'when coordinates are of wrong object type' do
        it 'should return false' do
          array = ['A', 1]
          expect(chess_board.valid_coordinate?(array)).to eq(false)
        end
      end
    end
  end
end
