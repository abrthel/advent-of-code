require 'strscan'
puzzle_input = File.read('09-stream-processing-input')

# Hackity Hack Hack parse.
$GARBAGE_COUNT = 0

module Parser
  extend self
    
  PARSE_MAP = {
    '{' => 'group',
    '<' => 'garbage',
    ',' => 'sibling'
  }
  
  def call(stream)
    scanner = ::StringScanner.new(stream)
    $GARBAGE_COUNT = 0 # Reset out hacky garbage counter.
    parse(scanner)
  end
  
  private 
  
  def parse(scanner)
    char = scanner.getch
    __send__(:"parse_#{PARSE_MAP[char]}", scanner)
  end
  
  def parse_group(scanner)
    children = parse_group_children(scanner)
    children.empty? ? [:group] : [:group, children]
  end
  
  def parse_group_children(scanner, children=[])
    peek = scanner.peek(1)
    
    until peek == '}' || peek == ''
      result = parse(scanner)
      if result.is_a?(Array)
        children << result
      end
      peek = scanner.peek(1)
    end
    scanner.getch # advance the scanner past the '}'
    
    children
  end

  # Parse method already popped the ','
  # so just keep parsing
  def parse_sibling(scanner)
    parse(scanner)
  end
  
  # Get rid of all the garbage input
  def parse_garbage(scanner)
    garbage = nil
    while garbage != '>'
      garbage = scanner.getch
      garbage = parse_ignore(scanner) if garbage == '!'
      
      # Purely for Part 2
      if garbage != :ignore && garbage != '>'
        $GARBAGE_COUNT += 1
      end
    end
    :garbage
  end

  def parse_ignore(scanner)
    scanner.getch # Skips past the next token
    :ignore
  end
end

def count_score(ast, level=1)
  _, children = ast
  score = level
  return score if children.nil?
  
  children.each do |child|
    score += count_score(child, level + 1 )
  end
  
  score
end

puts "\n  Part One"
puts "(exp == act)\n"

test_inputs = [
  ["{}", 1],
  ["{{{}}}", 6],
  ["{{},{}}", 5],
  ["{{{},{},{{}}}}", 16],
  ["{<a>,<a>,<a>,<a>}", 1],
  ["{<a>,{<a>},<a>,<a>}", 3],
  ["{{<ab>},{<ab>},{<ab>},{<ab>}}", 9],
  ["{{<!!>},{<!!>},{<!!>},{<!!>}}", 9],
  ["{{<a!>},{<a!>},{<a!>},{<ab>}}", 3]
]


test_inputs.each do |(input, groups)|
  puts "Test Case: #{groups} == #{count_score(Parser.call(input))}"
end

puts "Solution: #{count_score(Parser.call(puzzle_input))}"

test_inputs_2 = [
  ["{<>}", 0],
  ["{<random characters>}", 17],
  ["{<<<<>}", 3],
  ["{<{!>}>}", 2],
  ["{<!!>}", 0],
  ["{<!!!>>}", 0],
  ["{<{o\"i!a,<{i<a>", 10]
]

puts "\n\n  Part Two"
puts "(exp == act)\n"

test_inputs_2.each do |(input, groups)|
  Parser.call(input)
  puts "Test Case: #{groups} == #{$GARBAGE_COUNT}"
end

Parser.call(puzzle_input)
puts "Solution: #{$GARBAGE_COUNT}"