# frozen-string-literal: true

require_relative '../lib/chess_piece'

describe ChessPiece do
  subject(:chess_piece) { ChessPiece.new(unicode_queen) }
  let(:unicode_queen) { '🨁' }

  describe '#position=' do
    context 'when the coordinate is valid' do
      it 'should assign file' do
        valid_coordinate = 'H5'
        file = 'H'
        expect { chess_piece.position = valid_coordinate }.to change { chess_piece.file }.to(file)
      end

      it 'should assign rank' do
        valid_coordinate = 'F8'
        rank = '8'
        expect { chess_piece.position = valid_coordinate }.to change { chess_piece.rank }.to(rank)
      end

      it 'should assign position' do
        valid_coordinate = 'B1'
        expect { chess_piece.position = valid_coordinate }.to change { chess_piece.position }.to(valid_coordinate)
      end
    end

    context 'when the coordinate is invalid' do
      before { allow(chess_piece).to receive(:puts).once }

      it 'should notify the user that the coordinate is invalid' do
        error_message = 'D10 is not a valid chess coordinate.'
        invalid_coordinate = 'D10'
        expect(chess_piece).to receive(:puts).with(error_message).once
        chess_piece.position = invalid_coordinate
      end

      it 'should not assign a position' do
        invalid_coordinate = '1023'
        expect { chess_piece.position = invalid_coordinate }.not_to change { chess_piece.position }
      end
    end
  end

  describe '#valid_coordinate?' do
    context 'when the coordinate is valid' do
      it 'should return true' do
        valid_coordinate = 'B2'
        expect(chess_piece.valid_coordinate?(valid_coordinate)).to eq(true)
      end
    end

    context 'when the coordinate is invalid' do
      it 'should return false' do
        invalid_coordinate = 'B-2'
        expect(chess_piece.valid_coordinate?(invalid_coordinate)).to eq(false)
      end
    end
  end

  describe '#to_vector' do
    context 'when the coordinate is valid' do
      it 'should return the coordinate converted to a vector' do
        valid_coordinate = :D5
        vector = [4, 3]
        expect(chess_piece.to_vector(valid_coordinate)).to eq(vector)
      end
    end

    context 'when the coordinate is invalid' do
      it 'should return nil' do
        invalid_coordinate = 'A106'
        expect(chess_piece.to_vector(invalid_coordinate)).to be_nil
      end
    end
  end

  describe '#to_coordinate' do
    context 'when the vector is valid' do
      it 'should return the vector converted to a coordinate' do
        valid_vector = [7, 7]
        coordinate = 'H8'
        expect(chess_piece.to_coordinate(valid_vector)).to eq(coordinate)
      end
    end

    context 'when the vector is invalid' do
      it 'should return nil' do
        invalid_vector = [10, 7]
        expect(chess_piece.to_coordinate(invalid_vector)).to be_nil
      end
    end
  end

  describe '#valid_coordinate?' do
    context 'when the coordinate is valid' do
      it 'should return true when the coordinate is a string' do
        valid_string = 'F4'
        expect(chess_piece.valid_coordinate?(valid_string)).to eq(true)
      end

      it 'should return true when the coordinate is a symbol' do
        valid_symbol = :F4
        expect(chess_piece.valid_coordinate?(valid_symbol)).to eq(true)
      end
    end

    context 'when the coordinate is invalid' do
      context 'when the coordinate is not a valid chess coordinate' do
        it 'should return false' do
          invalid_coordinate = 'C12'
          expect(chess_piece.valid_coordinate?(invalid_coordinate)).to eq(false)
        end
      end

      context 'when the coordinate is of the wrong object type' do
        it 'should return false when the coordinate is an array' do
          array = ['D7']
          expect(chess_piece.valid_coordinate?(array)).to eq(false)
        end

        it 'should return false when the coordinate is a hash' do
          hash = { C: 8 }
          expect(chess_piece.valid_coordinate?(hash)).to eq(false)
        end

        it 'should return false when the coordinate is an integer' do
          integer = 24
          expect(chess_piece.valid_coordinate?(integer)).to eq(false)
        end

        it 'should return false when the coordinate is a float' do
          float = 5.3
          expect(chess_piece.valid_coordinate?(float)).to eq(false)
        end

        it 'should return false when the coordinate is a range' do
          range = (2..6)
          expect(chess_piece.valid_coordinate?(range)).to eq(false)
        end
      end
    end
  end

  describe '#valid_vector?' do
    context 'when the vector is valid' do
      it 'should return true' do
        valid_vector = [5, 6]
        expect(chess_piece.valid_vector?(valid_vector)).to eq(true)
      end
    end

    context 'when the vector is invalid' do
      it 'should return false when the first integer is bigger than 7' do
        invalid_vector = [10, 5]
        expect(chess_piece.valid_vector?(invalid_vector)).to eq(false)
      end

      it 'should return false when the last integer is bigger than 7' do
        invalid_vector = [2, 24]
        expect(chess_piece.valid_vector?(invalid_vector)).to eq(false)
      end

      it 'should return false when the first integer is negative' do
        invalid_vector = [-2, 1]
        expect(chess_piece.valid_vector?(invalid_vector)).to eq(false)
      end

      it 'should return false when the last integer is negative' do
        invalid_vector = [4, -6]
        expect(chess_piece.valid_vector?(invalid_vector)).to eq(false)
      end
    end

    context 'when the vector array is of wrong length' do
      it 'should return false when the array length is smaller than 2' do
        invalid_vector = [2]
        expect(chess_piece.valid_vector?(invalid_vector)).to eq(false)
      end

      it 'should return false when the array length is bigger than 2' do
        invalid_vector = [1, 6, 2]
        expect(chess_piece.valid_vector?(invalid_vector)).to eq(false)
      end
    end

    context 'when the vector array items are not of type integer' do
      it 'should return false' do
        invalid_vector = [3.0, '2']
        expect(chess_piece.valid_vector?(invalid_vector)).to eq(false)
      end
    end
  end
end
