def get_next_point(snake, direction)
  [snake.last[0] + direction[0], snake.last[1] + direction[1]]
end

def inside_map?(point, dimensions)
  answer_one = point[0].between?(0, dimensions[:width] - 1)
  answer_two = point[1].between?(0, dimensions[:height] - 1)

  answer_one && answer_two
end

def generate_map_array(dimensions)
  map = Array.new(dimensions[:width] * dimensions[:height]) { Array.new(2, 0) }
  index = 0
  while index < map.size
    map[index][0] += index / dimensions[:width]
    map[index][1] += index % dimensions[:height]
    index += 1
  end

  map
end

def move(snake, direction)
  new_snake = grow(snake, direction)
  new_snake.delete_at(0) if new_snake != nil
  puts snake.to_s
  new_snake
end

def grow(snake, direction)
  new_snake = nil
  next_point = get_next_point(snake, direction)
  if snake.find_index(next_point) == nil
    new_snake = snake.dup
    new_snake << next_point
  end

  new_snake
end

def new_food(food, snake, dimensions)
  points_not_in_use = generate_map_array(dimensions) - (snake + food)
  random_index = rand(points_not_in_use.size)
  points_not_in_use[random_index]
end

def obstacle_ahead?(snake, direction, dimensions)
  next_point = get_next_point(snake, direction)

  snake.find_index(next_point) != nil || !inside_map?(next_point, dimensions)
end

def danger?(snake, direction, dimensions)
  if obstacle_ahead?(snake, direction, dimensions) == false
    new_snake = move(snake, direction)
    obstacle_ahead?(new_snake, direction, dimensions)
  else
    true
  end
end
