# frozen-string-literal: true

# Chess board paths for chess pieces
module Pathable
  PATH_MARKER = "\e[32m* \e[0m"

  def add_path(moveset, chess_board)
    moveset.each do |pos|
      chess_board.place(pos, PATH_MARKER) if chess_board.field_empty?(pos)
    end
  end

  def remove_path(moveset, chess_board)
    moveset.each do |pos|
      chess_board.remove(pos) if chess_board.at(pos) == PATH_MARKER
    end
  end

  def display_path(moveset, chess_board)
    add_path(moveset, chess_board)
    puts chess_board
    remove_path(moveset, chess_board)
  end
end
