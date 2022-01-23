# frozen-string-literal: true

require_relative '../lib/chess_board'

describe ChessBoard do
  subject(:chess_board) { described_class.new }
  let(:empty_field) { ' ' }

  describe '#to_s' do
    context 'when fields are empty' do
      it 'should print the empty board' do
        expect(chess_board.to_s).to eq(
          <<~BOARD
            8 \e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m
            7 \e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m
            6 \e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m
            5 \e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m
            4 \e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m
            3 \e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m
            2 \e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m
            1 \e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m
               a  b  c  d  e  f  g  h
          BOARD
        )
      end
    end

    context 'when some fields are occupied' do
      before do
        knight = '🨄'
        8.times { |i| chess_board.fields[i][i] = knight }
      end

      it 'should print the board' do
        expect(chess_board.to_s).to eq(
          <<~BOARD
            8 \e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m 🨄 \e[0m
            7 \e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m 🨄 \e[0m\e[48;2;222;184;135m   \e[0m
            6 \e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m 🨄 \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m
            5 \e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m 🨄 \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m
            4 \e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m 🨄 \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m
            3 \e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m 🨄 \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m
            2 \e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m 🨄 \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m
            1 \e[48;2;198;122;8m 🨄 \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m\e[48;2;198;122;8m   \e[0m\e[48;2;222;184;135m   \e[0m
               a  b  c  d  e  f  g  h
          BOARD
        )
      end
    end
  end

  describe '#place' do
    context 'when the coordinate and symbol is valid' do
      context 'when the field at the coordinate is empty' do
        it 'should place a symbol at the coordinate' do
          coordinate = 'D5'
          symbol = '🨁'
          chess_board.place(coordinate, symbol)
          expect(chess_board.fields[4][3]).to eq(symbol)
        end
      end

      context 'when the field is not empty' do
        before { chess_board.fields[6][5] = 'X' }

        it 'should change the symbol' do
          coordinate = 'F7'
          symbol = '🨁'
          expect { chess_board.place(coordinate, symbol) }.to change { chess_board.fields[6][5] }.to(symbol)
        end
      end
    end

    context 'when the coordinate is invalid' do
      it 'should not place the symbol' do
        coordinate = 'B202'
        symbol = '🩒'
        expect { chess_board.place(coordinate, symbol) }.not_to change { chess_board.fields }
      end
    end

    context 'when the symbol is invalid' do
      it 'should not place the symbol at the coordinate' do
        coordinate = 'C1'
        symbol = 'xYx'
        expect { chess_board.place(coordinate, symbol) }.not_to change { chess_board.fields }
      end
    end
  end

  describe '#remove' do
    context 'when a symbol is placed at the coordinate' do
      it 'should remove the symbol' do
        coordinate = 'C6'
        symbol = '🩒'
        chess_board.place(coordinate, symbol)
        expect { chess_board.remove(coordinate) }.to change { chess_board.fields[5][2] }.from(symbol).to(empty_field)
      end
    end

    context 'when no symbol is placed at the coordinate' do
      it 'should not remove anything' do
        coordinate = 'D624'
        expect { chess_board.remove(coordinate) }.not_to change { chess_board.fields }
      end
    end
  end

  describe '#move' do
    context 'when the start and target coordinates are valid' do
      let(:start_coordinate) { 'H1' }
      let(:target_coordinate) { 'H5' }
      let(:symbol_at_start) { '🨂' }

      context 'when a symbol is placed at the start coordinate' do
        before do
          chess_board.place(start_coordinate, symbol_at_start)
          chess_board.move(start_coordinate, target_coordinate)
        end

        it 'should move the symbol at the start coordinate to the target coordinate' do
          expect(chess_board.fields[4][7]).to eq(symbol_at_start)
        end

        it 'should remove the symbol from the start coordinate' do
          expect(chess_board.fields[0][7]).to eq(empty_field)
        end
      end

      context 'when a symbol is placed at the start and target coordinate' do
        before do
          symbol_at_target = '🨾'
          chess_board.place(start_coordinate, symbol_at_start)
          chess_board.place(target_coordinate, symbol_at_target)
          chess_board.move(start_coordinate, target_coordinate)
        end

        it 'should replace the symbol at the target coordinate' do
          expect(chess_board.fields[4][7]).to eq(symbol_at_start)
        end
      end

      context 'when no symbol is placed at the start coordinate' do
        it 'should do nothing' do
          chess_board.place(target_coordinate, symbol_at_start)
          expect { chess_board.move(start_coordinate, target_coordinate) }.not_to change { chess_board.fields }
        end
      end
    end

    context 'when the start coordinate is invalid' do
      it 'should do nothing' do
        start_coordinate = 'J2'
        target_coordinate = 'H7'
        expect { chess_board.move(start_coordinate, target_coordinate) }.not_to change { chess_board.fields }
      end
    end

    context 'when the target coordinate is invalid' do
      it 'should do nothing' do
        start_coordinate = 'C3'
        target_coordinate = 'Z9'
        expect { chess_board.move(start_coordinate, target_coordinate) }.not_to change { chess_board.fields }
      end
    end
  end

  describe '#at' do
    context 'when the coordinate is valid' do
      context 'when the field at the coordinate is empty' do
        it "should return ' '" do
          coordinate = 'B4'
          expect(chess_board.at(coordinate)).to eq(empty_field)
        end
      end

      context 'when the field at the coordinate is not empty' do
        before do
          coordinate = 'B6'
          symbol = '🨂'
          chess_board.place(coordinate, symbol)
        end

        it 'should return the symbol at the coordinate' do
          coordinate = 'B6'
          expected_symbol = '🨂'
          expect(chess_board.at(coordinate)).to eq(expected_symbol)
        end
      end
    end

    context 'when the coordinate is invalid' do
      it 'should return nil' do
        coordinate = 'B500'
        expect(chess_board.at(coordinate)).to be_nil
      end
    end
  end

  describe '#invert' do
    let(:x_row) { x_row = Array.new(8, 'X') }
    let(:y_row) { y_row = Array.new(8, 'Y') }

    before do
      chess_board.fields[0] = x_row
      chess_board.fields[7] = y_row
    end

    it 'should switch the @inverted instance variable' do
      expect { chess_board.invert }.to change { chess_board.inverted? }.to(true)
    end

    it 'should invert the board' do
      expect { chess_board.invert }.to change { chess_board.fields[0] }.from(x_row).to(y_row)
    end
  end

  describe '#clear' do
    before do
      pawn_symbol = '🨾'
      ('A'..'H').each { |file| chess_board.place("#{file}2", pawn_symbol) }
    end

    it 'should clear the board' do
      current_fields = chess_board.fields
      clear_board = Array.new(8) { Array.new(8, ' ') }
      expect { chess_board.clear }.to change { chess_board.fields }.from(current_fields).to(clear_board)
    end
  end

  describe '#field_empty?' do
    context 'when the field at the coordinate is empty' do
      it 'should return true' do
        coordinate = 'D3'
        expect(chess_board.field_empty?(coordinate)).to eq(true)
      end
    end

    context 'when the field at the coordinate is not empty' do
      let(:coordinate) { 'A5' }
      before do
        pawn_symbol = '🨾'
        chess_board.place(coordinate, pawn_symbol)
      end

      it 'should return false' do
        expect(chess_board.field_empty?(coordinate)).to eq(false)
      end
    end
  end

  describe '#valid_coordinate?' do
    context 'when the coordinate is a valid chess coordinate' do
      it 'should return true when the coordinate is passed as a symbol' do
        coordinate_symbol = :F8
        expect(chess_board.valid_coordinate?(coordinate_symbol)).to eq(true)
      end

      it 'should return true when the coordinate is passed as a string' do
        coordinate_string = 'F4'
        expect(chess_board.valid_coordinate?(coordinate_string)).to eq(true)
      end
    end

    context 'when the coordinate is not a valid chess coordinate' do
      context 'when the coordinate is out of range' do
        it 'should return false' do
          invalid_coordinate = 'C14'
          expect(chess_board.valid_coordinate?(invalid_coordinate)).to eq(false)
        end
      end

      context 'when  the coordinate is of wrong object type' do
        it 'should return false' do
          array_coordinate = ['A', 1]
          expect(chess_board.valid_coordinate?(array_coordinate)).to eq(false)
        end
      end
    end
  end

  describe '#valid_symbol?' do
    context 'when the symbol is valid' do
      context 'when the symbol is colored' do
        it 'should return true when the symbol length is 1' do
          colored_king = "\e[0;37;49m🨀\e[0m"
          expect(chess_board.valid_symbol?(colored_king)).to eq(true)
        end

        it 'should return true when the symbol length is 2' do
          colored_king = "\e[0;37;49m🨀 \e[0m"
          expect(chess_board.valid_symbol?(colored_king)).to eq(true)
        end
      end

      context 'when the symbol is not colored' do
        it 'should return true when the symbol length is 1' do
          queen_symbol = '🨁'
          expect(chess_board.valid_symbol?(queen_symbol)).to eq(true)
        end
      end
    end

    context 'when the symbol is invalid' do
      context 'when the symbol is not colored and not of a length of 1' do
        it 'should return false' do
          invalid_symbol = 'QUEEN'
          expect(chess_board.valid_symbol?(invalid_symbol)).to eq(false)
        end
      end

      context 'when the symbol is colored and not of a length of either 1 or 2' do
        it 'should return false' do
          invalid_colored_symbol = "\e[0;37;49mKING\e[0m"
          expect(chess_board.valid_symbol?(invalid_colored_symbol)).to eq(false)
        end
      end
    end
  end

  describe '#inverted?' do
    context 'when the chess board is inverted' do
      before { chess_board.invert }

      it 'should return true' do
        expect(chess_board.inverted?).to eq(true)
      end
    end

    context 'when the chess board is not inverted' do
      it 'should return false' do
        expect(chess_board.inverted?).to eq(false)
      end
    end
  end
end
