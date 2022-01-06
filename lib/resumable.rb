# frozen-string-literal: true

require 'yaml'

# save chess game state to yaml
module Resumable
  SAVES_DIR = './saves/'
  MAX_SAVES_COUNT = 10
  PERMITTED_CLASSES = %i[ChessPiece Symbol].freeze

  def save
    delete_oldest_save if savegames.length >= MAX_SAVES_COUNT
    Dir.mkdir(SAVES_DIR) unless Dir.exist?(SAVES_DIR)
    savedata = YAML.dump({
      active_player_name: active_player.name,
      turn: turn,
      player1: save_data(player1),
      player2: save_data(player2),
      chess_board: save_data(chess_board)
    })
    save_to_file(savedata)
  end

  def load(filepath)
    data = unpack_data(filepath)
    %i[player1 player2 chess_board].each { |v| load_data(send(v), data[v]) }
    @active_player = data[:active_player_name] == player2.name ? player2 : player1
    @turn = data[:turn]
  end

  private

  def save_data(object)
    object.instance_variables.each_with_object({}) do |var, hash|
      hash[var] = object.instance_variable_get(var)
    end
  end

  def save_to_file(savedata)
    File.open("#{SAVES_DIR}#{save_name}", 'w') { |file| file << savedata }
  end

  def unpack_data(filepath)
    YAML.load_file(filepath, permitted_classes: PERMITTED_CLASSES)
  end

  def load_data(object, savedata)
    savedata.each { |var, data| object.instance_variable_set(var, data) }
  end

  def savegames
    return [] unless Dir.exist?(SAVES_DIR)

    Dir.children(SAVES_DIR).sort_by do |file|
      File.birthtime("#{SAVES_DIR}#{file}").to_i
    end
  end

  def save_name
    "#{Time.now.strftime("#{player1.name}-#{player2.name}-%d-%B-%Y-%H_%M_%S")}.save"
  end

  def delete_oldest_save
    File.delete(File.realpath("#{SAVES_DIR}#{savegames.shift}"))
  end
end
