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

  def place(position, symbol)
    vec = vector(position)
    return unless vec

    fields[vec.first][vec.last] = symbol if field_empty?(position)
  end

  def vector(position)
    [position[1].to_i - 1, position[0].downcase.ord - 97] if valid_position?(position)
  end

  def field_empty?(position)
    vec = vector(position)
    fields[vec.first][vec.last] == ' '
  end

  def valid_position?(position)
    position[/^([a-hA-H])([1-8])$/] != nil
  end

  private

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
