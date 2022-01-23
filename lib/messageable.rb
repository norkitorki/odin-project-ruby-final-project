# frozen-string-literal: true

# Chess messages for chess console game
module Messageable
  def main_menu_message
    <<~MESSAGE
      Welcome to a Game of Chess!

      🨀  #{color(player1.name, 33)}
      #{color('🨀 ', 90)} #{color(player2.name, 33)}

      Input...
        #{game_options('start', 's')} to start/resume the game.
        #{game_options('computer', 'c')} to enable/disable the Computer.
        #{game_options('white', 'w')} to assign a Player to the White Pieces.
        #{game_options('black', 'b')} to assign a Player to the Black Pieces.
        #{game_options('save')} to save the current game.
        #{game_options('load', 'l')} to load a previously saved game.
        #{game_options('reset', 'r')} to reset the game.
        #{game_options('exit', 'e')} to exit.\n
    MESSAGE
  end

  def select_save_game_message
    <<~MESSAGE
      Please input a savegame index to load (input '#{color('c', 31)}' to cancel)

      #{savegames.map.with_index { |save, i| "#{color((i + 1).to_s, 32)} - #{save}" }.join("\n")}\n
    MESSAGE
  end

  def previous_move_message
    return '' unless @previous_move

    piece_type = @previous_move[:piece].type.capitalize
    initial_position = @previous_move[:initial_position]
    destination = @previous_move[:piece].position

    if @previous_move[:capture]
      capture = @previous_move[:capture]
      "#{opponent.name} has captured #{capture.type} at #{destination}."
    else
      "#{opponent.name} has moved #{piece_type} from #{initial_position} to #{destination}."
    end
  end

  def move_opening_message(player_pieces, opponent_pieces, reverted)
    king = active_player.king.first
    <<~MESSAGE
      \e[0;36;49mTurn #{turn}\e[0m #{previous_move_message}
      #{"\e[0;31;49mKing at #{king.position} is checked!\e[0m\n" if king.check?(player_pieces, opponent_pieces)}
      #{"\e[0;31;49mReset last move due to checked position.\e[0m\n\n" if reverted}#{chess_board}
      #{piece_selection_message}
    MESSAGE
  end

  def move_reset_message
    "\e[0;31;49mLast move reverted due to checked position.\e[0m\n\n"
  end

  def piece_selection_message(player = active_player, pieces = player.pieces)
    <<~MESSAGE
      #{color("#{player.name}'s", 33)} turn. Input #{game_options('exit', 'e', 31)} to return to the main menu.

      Please choose a chess piece(#{color('coordinate', 32)}) to move:

      [#{pieces.map { |p| " #{color(p.position, 32)}: #{sanitized_symbol(p.symbol)}" }.join}]
    MESSAGE
  end

  def game_saved_message(savegame)
    "Game was successfully saved as #{savegame}"
  end

  def piece_movement_message(piece, moveset)
    <<~MESSAGE
      \nWhere would you like to move the #{piece.type.capitalize} at #{piece.position}? (input '#{color('c', 31)}' to cancel)

      [ #{moveset.map { |pos| color(pos, 32) }.join(', ')} ]\n
    MESSAGE
  end

  def empty_moveset_message(piece)
    puts color("\n#{piece.type.capitalize} at #{piece.position} cannot move anywhere.", 31)
    sleep 2
  end

  def stalemate_message(turn)
    color("\nThe Game ended in a Stalemate after turn #{turn - 1}.", 31)
  end

  def dead_draw_message(turn)
    color("\nThe Game ended in a Dead Draw after turn #{turn - 1}.", 31)
  end

  def check_mate_message(player, turn)
    color("\nCheck Mate! #{player.name} has won after turn #{turn - 1}.", 32)
  end

  private

  def color(string, colorcode)
    "\e[0;#{colorcode};49m#{string}\e[0m"
  end

  def game_options(option1, option2 = nil, colorcode = 32)
    "'#{color(option1, colorcode)}'#{" or '#{color(option2, colorcode)}'" if option2}"
  end

  def sanitized_symbol(symbol)
    symbol.include?(' ') ? symbol : "#{symbol} "
  end
end
