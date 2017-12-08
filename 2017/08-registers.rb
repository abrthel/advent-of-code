puzzle_input = File.read('08-registers-input')

ACTION_MAP = {
  "inc" => :+,
  "dec" => :-
}

OPERATION_MAP = {
  "!=" => -> (left, right) { left != right },
  "==" => -> (left, right) { left == right },
  ">=" => -> (left, right) { left >= right },
  "<=" => -> (left, right) { left <= right },
   ">" => -> (left, right) { left  > right },
   "<" => -> (left, right) { left  < right },
}

def parse_input(input)
  input
    .split("\n")
    .map {|line| 
      _, reg, act, num, cond_reg, op, right = 
        /^(\w+) (\w+) (-?\d+) if (\w+) (!=|>=|<=|==|>|<) (-?\d+)/.match(line).to_a
        
      {
        register: reg.to_sym,
        action: ACTION_MAP[act],
        value: num.to_i,
        cond_reg: cond_reg.to_sym,
        op: OPERATION_MAP[op],
        right: right.to_i
      }
    }
end

def execute_registers(instruction_list)
  instruction_list.each_with_object({}) do |inst, registers|
    
    cur_reg_val = registers.fetch(inst[:register]) { 0}
    left = registers.fetch(inst[:cond_reg]) { 0 }
    
    if inst[:op].call(left, inst[:right])
      registers[inst[:register]] = cur_reg_val.send(inst[:action], inst[:value])
      yield(inst[:register], registers[inst[:register]]) if block_given?
    end
  end
end

def largest_register(executed_registers)
  reg = nil
  val = 0
  
  executed_registers.each do |k, v|
    if v > val
      reg = k
      val = v
    end
  end
  
  [reg, val]
end

def largest_register_held(instruction_list)
  reg = nil
  val = 0
  
  execute_registers(instruction_list) do |k, v|
    if v > val
      reg = k
      val = v
    end
  end
  
  [reg, val]
end

puts "\n  Part One"
puts "(exp == act)\n"

test_input = <<~INPUT
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
INPUT


test_input_registers = execute_registers(parse_input(test_input))
puts "Test Case: 1 == #{largest_register(test_input_registers)}"

instruction_list = execute_registers(parse_input(puzzle_input))
puts "Solution: #{largest_register(instruction_list)}"


puts "\n\n  Part Two"
puts "(exp == act)\n"

test_input_registers = parse_input(test_input)
puts "Test Case: 10 == #{largest_register_held(test_input_registers)}"

instruction_list = parse_input(puzzle_input)
puts "Solution: #{largest_register_held(instruction_list)}"