puzzle_input = [157,222,1,2,177,254,0,228,159,140,249,187,255,51,76,30]

def knot_hash(size, lengths)
  list = (0...size).to_a
  pos, skip = 0, 0
  
  lengths.each do |len|
    len_range = 0...len
    list[len_range] = list[len_range].reverse
    list = list.rotate(len + skip)
    pos += len + skip
    skip += 1
    list.rotate(size - (pos % size))
  end
  
  res = list.rotate(-pos)
  res[0] * res[1] 
end


def knot_hash_2(size, input)
  input = input.strip.bytes + [17, 31, 73, 47, 23]
  list = (0...size).to_a
  pos, skip = 0, 0

  64.times {
    input.each {|byte|
      byte_range = 0...byte
      list[byte_range] = list[byte_range].reverse
      list = list.rotate(byte + skip)
      pos += byte + skip
      skip += 1;
    }
  } 
  
  res = list.rotate(-pos); 
  res.each_slice(16).map {|s| s.reduce(&:^) }.map {|x| x.to_s(16) }.join
end

puts "\n  Part One"
puts "(exp == act)\n"

test_inputs = [
  [[3, 4, 1, 5], 12, 5]
]

test_inputs.each do |(input, res, list_size)|
  puts "Test Case: #{res} == #{knot_hash(list_size, input)}"
end
puts "Solution: #{knot_hash(256, puzzle_input)}"


puts "\n\n  Part Two"
puts "(exp == act)\n"

test_inputs_2 = [
  ['', "a2582a3a0e66e6e86e3812dcb672a272"],
  ['AoC 2017', "33efeb34ea91902bb2f59c9920caa6cd"],
  ['1,2,3', "3efbe78a8d82f29979031a4aa0b16a9d"],
  ['1,2,4', "63960835bcdc130f0b66d7ff4f6a5a8e"]
]

test_inputs_2.each do |(input, res)|
  puts "Test Case: #{res} == #{knot_hash_2(256, input)}"
end
puts "Solution: #{knot_hash_2(256, puzzle_input.join(','))}"