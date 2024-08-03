require './base_player.rb'

class YourPlayer < BasePlayer
  def next_point(time:)
    @visited_points ||= []
    @queue ||= []
    @current_position ||= { row: 0, col: 0 }

    if @visited_points.empty?
      @visited_points.push(@current_position)
      @queue.push(@current_position)
      return @current_position
    end

    if @queue.empty?
      return @current_position
    end

    @current_position = @queue.shift

    neighbors(@current_position).each do |neighbor|
      next if @visited_points.include?(neighbor) || !grid.is_valid_move?(from: @current_position, to: neighbor)

      @queue.push(neighbor)
      @visited_points.push(neighbor)
      grid.visit(neighbor)
    end

    puts "Player #{name} at #{time} moves to #{@current_position}"
    @current_position
  end

  def grid
    game.grid
  end

  private

  def neighbors(point)
    row, col = point[:row], point[:col]
    neighbors = []

    [
      { row: row - 1, col: col },
      { row: row + 1, col: col },
      { row: row, col: col - 1 },
      { row: row, col: col + 1 }
    ].each do |neighbor|
      if neighbor[:row].between?(0, grid.max_row) && neighbor[:col].between?(0, grid.max_col)
        neighbors.push(neighbor)
      end
    end

    neighbors
  end
end
