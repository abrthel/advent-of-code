puzzle_input = "0 5 10 0 11 14 13 4 11 8 8 7 1 4 12 11"

def memory_reallocation_count(input, depth=1)
  mem = input.is_a?(Array) ? input.dup : input.split.map(&:to_i)
  cycles = 0
  configurations = {}        
  
  until configurations.has_key?(mem.to_s)
    configurations[mem.to_s] = cycles
    
    # Find the memory bank with the most blocks
    # and adjust pointer
    pointer = mem.index(mem.max)
    value = mem[pointer] 
    mem[pointer] = 0

    # Redistribute the blocks
    value.times do |v|
      mem[(pointer + v + 1) % mem.size] += 1
    end
    
    cycles += 1
  end
  
  depth > 1 ? memory_reallocation_count(mem, depth - 1) : cycles
end


puts "\n  Part One"
puts "(exp == act)\n"

puts "Test Case: 5 == #{memory_reallocation_count("0 2 7 0")}"
puts "Solution: #{memory_reallocation_count(puzzle_input)}"


puts "\n\n  Part Two"
puts "(exp == act)\n"

puts "Test Case: 4 == #{memory_reallocation_count("2 4 1 2")}"
puts "Solution: #{memory_reallocation_count(puzzle_input, 2)}"