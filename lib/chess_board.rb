# frozen-string-literal: false

# Chess Board Class
class ChessBoard
  attr_reader :fields

  def initialize
    @fields = Array.new(8) { Array.new(8, ' ') }
  end

  def to_s
    top << rows << bottom
  end

  def place(coordinate, symbol)
    return unless valid_coordinate?(coordinate) && symbol.to_s.length == 1

    vec = vector(coordinate)
    fields[vec.first][vec.last] = symbol if field_empty?(coordinate)
  end

  def at(coordinate)
    return unless valid_coordinate?(coordinate)

    vec = vector(coordinate)
    fields[vec.first][vec.last]
  end

  def field_empty?(coordinate)
    return unless valid_coordinate?(coordinate)

    vec = vector(coordinate)
    fields[vec.first][vec.last] == ' '
  end

  def valid_coordinate?(coordinate)
    coordinate.to_s[/^([a-hA-H])([1-8])$/] != nil
  end

  private

  def vector(coordinate)
    [coordinate[1].to_i - 1, coordinate[0].downcase.ord - 97]
  end

  def rows
    fields.reverse.map.with_index do |row, i|
      "#{8 - i} ┃ #{row.join(' │ ')} ┃\n"
    end.join(row_seperator)
  end

  def row_seperator
    '  ┠' << Array.new(8, '───').join('┼') << "┨\n"
  end

  def top
    "  ┏━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┓\n"
  end

  def bottom
    "  ┗━━━┷━━━┷━━━┷━━━┷━━━┷━━━┷━━━┷━━━┛\n    A   B   C   D   E   F   G   H\n"
  end
end
