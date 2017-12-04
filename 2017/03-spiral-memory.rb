require 'mathn'

puzzle_input = 361527

def step_count(position)
  target_value = position
  current_value = 1 # start at one
  current_coord = [0,0]
  
  # Get the size of the grid by
  # taking the current position and finding
  # a square root value that is an integer.
  while Math.sqrt(position) % 1 != 0 do
    position += 1
  end
  n = Math.sqrt(position)

  # Turn directions
  right = [1,0]
  up    = [0,1]
  left  = [-1,0]
  down  = [0,-1]

  # Gets the number of steps per direction
  runs = n.downto(0).each_cons(2).to_a.flatten.reverse # [0,1,1,2,2,3,3,4,4,5]
  
  # Keeps cycling in a direction 
  direction = [right, up, left, down].cycle
  
  x, y, = 0, 0
  for run in runs
    next if run.zero? # Ignore the zero run
    dx, dy = direction.next
    run.times do 
      current_coord = [x+=dx, y+=dy]
      current_value += 1
      break if target_value == current_value
    end
  end
  
  # Add the coords together with their absolute values.
  current_coord.reduce(0) {|accum, v| accum += v.abs }
end

# Test all of the neighbours in the grid
def neighbours(grid, coords)
  x, y = coords
  n = [
        [1, 0], [1, 1], [0, 1], [-1, 1],
        [-1,0], [-1, -1], [0, -1], [1, -1]
      ]
  
  n
    .map { |i|
      nx, ny = i
      grid.fetch([x + nx,y + ny], 0)
    }
    .sum
end

def step_count_2(position)
  target_value = position
  current_value = 1 # start at one
  current_coord = [0,0]
  
  # This is a horribly inefficient way to do this
  # instead of holding onto all of the values, I should
  # only hold onto the values in locality of the current
  # square. That way old unneeded coords can be released
  # and we're not ever expanding a hash.
  grid = {current_coord => current_value}
  
  # Get the size of the grid by
  # taking the current position and finding
  # a square root value that is an integer.
  while Math.sqrt(position) % 1 != 0 do
    position += 1
  end
  n = Math.sqrt(position)

  # Turn directions
  right = [1, 0]
  up    = [0, 1]
  left  = [-1,0]
  down  = [0,-1]

  # Gets the number of steps per direction
  runs = n.downto(0).each_cons(2).to_a.flatten.reverse # [0,1,1,2,2,3,3,4,4,5]
  runs.shift(1) # [1,1,2,2,3,3,4,4,5]
  
  # Keeps cycling in a direction 
  direction = [right, up, left, down].cycle
  
  x, y, = 0, 0
  terminate = false
  for run in runs
    break if terminate
    dx, dy = direction.next
    
    run.times do
      break if terminate 
      current_coord = [x+=dx, y+=dy]
      current_value = neighbours(grid, current_coord)
      grid[current_coord] = current_value

      terminate = true if current_value >= target_value
    end
  end
  
  current_value
end

puts "\n  Part One"
puts "(exp == act)\n"

puts "Test Case: 3 == #{step_count(12)}"
puts "Test Case: 2 == #{step_count(23)}"
puts "Test Case: 31 == #{step_count(1024)}"
puts "Solution: #{step_count(puzzle_input)}"


puts "\n\n  Part Two"
puts "(exp == act)\n"

puts "Test Case: 1 == #{step_count_2(2)}"
puts "Test Case: 2 == #{step_count_2(3)}"
puts "Test Case: 4 == #{step_count_2(4)}"
puts "Test Case: 5 == #{step_count_2(5)}"
puts "Solution: #{step_count_2(puzzle_input)}"