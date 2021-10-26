# frozen-string-literal: true

# Chess board traversal module
module ChessTraversal
  def moveset
    return [] unless position

    right_up + right + right_down + down + left_down + left + left_up + up
  end

  def right_up(steps = 8)
    return [] unless position

    r_rank = rank.to_i
    moves = []
    (file.next..'H').each_with_index do |file, i|
      r_rank >= 8 || i == steps ? break : moves << "#{file}#{r_rank += 1}"
    end
    moves
  end

  def right(steps = 8)
    return [] unless position

    moves = []
    (file.next..'H').each_with_index do |file, i|
      i == steps ? break : moves << "#{file}#{rank.to_i}"
    end
    moves
  end

  def right_down(steps = 8)
    return [] unless position

    r_rank = rank.to_i
    moves = []
    (file.next..'H').each_with_index do |file, i|
      break if r_rank <= 1 || i == steps

      moves << "#{file}#{r_rank -= 1}"
    end
    moves
  end

  def down(steps = 8)
    return [] unless position

    moves = []
    (rank.to_i - 1).downto(1).map.with_index do |rank, i|
      i == steps ? break : moves << "#{file}#{rank}"
    end
    moves
  end

  def left_down(steps = 8)
    return [] unless position

    l_rank = rank.to_i
    moves = []
    ('A'...file).to_a.reverse.each_with_index do |file, i|
      l_rank <= 1 || i == steps ? break : moves << "#{file}#{l_rank -= 1}"
    end
    moves
  end

  def left(steps = 8)
    return [] unless position

    moves = []
    ('A'...file).to_a.reverse.each_with_index do |file, i|
      i == steps ? break : moves << "#{file}#{rank}"
    end
    moves
  end

  def left_up(steps = 8)
    return [] unless position

    l_rank = rank.to_i
    moves = []
    ('A'...file).to_a.reverse.each_with_index do |file, i|
      l_rank >= 8 || i == steps ? break : moves << "#{file}#{l_rank += 1}"
    end
    moves
  end

  def up(steps = 8)
    return [] unless position

    moves = []
    (rank.to_i + 1).upto(8).each_with_index do |rank, i|
      i == steps ? break : moves << "#{file}#{rank}"
    end
    moves
  end
end
