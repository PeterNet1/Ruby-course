class RationalSequence
  include Enumerable

  def initialize(size = 1)
    @sequence_size = size
  end

  def nil_duplicates(array)
    new_array = array
    duplicates = {}
    index_1, index_2 = 0, 0
    while index_1 < new_array.size
      if new_array.count(new_array[index_1]) > 1 && !duplicates.has_key?(new_array[index_1])
        duplicates[new_array[index_1]] = Array.new(1, index_1)
      elsif new_array.count(new_array[index_1]) > 1
        duplicates[new_array[index_1]] << index_1
      end
      index_1 += 1
    end

    duplicates.each_value do |value|
        index_2 = 1
        while index_2 < value.size
          new_array[value[index_2]] = nil
          index_2 += 1
        end
    end

    new_array
  end

  def group_rat_numbers(array)
    new_array = []
    number, array_index = 0, 0
    while array_index < array.size
      if array[array_index].nil? || array[array_index].numerator == number
        new_array[number] << array[array_index]
      else
        number += 1
        new_array[number] = Array.new
        new_array[number] << array[array_index]
      end
      array_index += 1
    end
    #puts new_array.drop(1).to_s
    new_array.drop(1)
  end

  def generate_rat_array(size)
    index_1, index_2 = 0, 0
    array = []
    while index_1 < size
      index_2 = 0
      while index_2 < size
        array << Rational(1 + index_1, 1 + index_2)
        index_2 += 1
      end
      index_1 += 1
    end
    array = nil_duplicates(array)
    array = group_rat_numbers(array)

    array
  end

  def snake_index_move(index_1, index_2, snake_direction)
    snake_direction = 0 if snake_direction > 3
    case snake_direction
      # move down
      when 0
        index_1 += 1
      # move diagonaly up-right
      when 1
        if index_1 > 0
          index_1 -= 1
          index_2 += 1
        end
      # move right
      when 2
        index_2 += 1
      # move diagonaly down-left
      when 3
        if index_2 > 0
          index_1 += 1
          index_2 -= 1
        end
    end

    [index_1, index_2, snake_direction]
  end

  def snake_index_next(index_1, index_2, snake_direction)
    test_1, test_2 = index_1, index_2
    if snake_direction == 1 || snake_direction == 3
      test_1, test_2, snake_direction = *snake_index_move(test_1, test_2, snake_direction)
      if index_1 == test_1 && index_2 == test_2
        snake_direction += 1
        index_1, index_2, snake_direction = *snake_index_move(index_1, index_2, snake_direction)
        snake_direction += 1
      else
        index_1, index_2, snake_direction = *snake_index_move(index_1, index_2, snake_direction)
      end
    else
      index_1, index_2, snake_direction = *snake_index_move(index_1, index_2, snake_direction)
      snake_direction += 1
    end

    [index_1, index_2, snake_direction]
  end

  def each
    array_index = 0
    index_1, index_2 = 0, 0
    snake_direction = 0
    array = generate_rat_array(@sequence_size)
    while array_index < @sequence_size
      if array[index_1][index_2].nil?
        index_1, index_2, snake_direction = *snake_index_next(index_1, index_2, snake_direction)
      else
        yield array[index_1][index_2]
        index_1, index_2, snake_direction = *snake_index_next(index_1, index_2, snake_direction)
        array_index += 1
      end
    end
  end
end

class FibonacciSequence
end

class PrimeSequence
end

class DrunkenMathematician
end
