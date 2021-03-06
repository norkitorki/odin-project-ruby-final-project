# frozen-string-literal: false

# console chess board
class ChessBoard
  attr_reader :files, :ranks, :fields

  def initialize
    @files = ('a'..'h').to_a
    @ranks = (1..8).to_a.reverse
    @inverted = false
    clear
  end

  def to_s
    board_squares << "\n   #{files.join('  ')}\n"
  end

  def place(coordinate, symbol)
    return unless valid_coordinate?(coordinate) && valid_symbol?(symbol.to_s)

    vec = vector(coordinate)
    fields[vec.first][vec.last] = symbol
  end

  def remove(coordinate)
    place(coordinate, ' ')
  end

  def move(start_coordinate, target_coordinate)
    return unless valid_move?(start_coordinate, target_coordinate)

    target_vec = vector(target_coordinate)
    fields[target_vec.first][target_vec.last] = at(start_coordinate)
    remove(start_coordinate)
  end

  def at(coordinate)
    return unless valid_coordinate?(coordinate)

    vec = vector(coordinate)
    fields[vec.first][vec.last]
  end

  def invert
    @inverted = !@inverted
    [@files, @ranks].each(&:reverse!)
    @fields.reverse!.map!(&:reverse)
  end

  def clear(reset: false)
    invert if reset && inverted?
    @fields = Array.new(8) { Array.new(8, ' ') }
  end

  def field_empty?(coordinate)
    at(coordinate).to_s == ' '
  end

  def valid_coordinate?(coordinate)
    coordinate.to_s[/^([a-hA-H])([1-8])$/] != nil
  end

  def valid_symbol?(symbol)
    colored_piece?(symbol) || symbol.length == 1
  end

  def inverted?
    @inverted
  end

  private

  def valid_move?(start, target)
    valid_coordinate?(start) && valid_coordinate?(target) && !field_empty?(start)
  end

  def colored_piece?(symbol)
    symbol.match?(/\[\d{1,2}m.{1,2}\e/)
  end

  def vector(coordinate)
    file_vec = coordinate[0].downcase.ord
    rank_vec = coordinate[1].to_i
    inverted? ? [8 - rank_vec, 96 - file_vec] : [rank_vec - 1, file_vec - 97]
  end

  def board_squares
    fields.reverse.map.with_index do |row, i|
      square = i.even? ? :light_square : :dark_square
      "#{ranks[i]} " << row.map do |s|
        s = send(square, s)
        square = square == :light_square ? :dark_square : :light_square
        s
      end.join
    end.join("\n")
  end

  def light_square(symbol = '')
    "\e[48;2;222;184;135m #{symbol}#{' ' unless colored_piece?(symbol)}\e[0m"
  end

  def dark_square(symbol = '')
    "\e[48;2;198;122;8m #{symbol}#{' ' unless colored_piece?(symbol)}\e[0m"
  end
end
