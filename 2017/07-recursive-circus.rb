puzzle_input = File.read('07-recursive-circus-input')

# Not happy with these solutions, there is is lots of duplication of work
# and quite frankly it's just ugly. Unfortunately I ran out of time on this one
# so this will have to do.
# Honestly, a well built Node class would work wonders on this solution

def parse_input(input)
  input
    .split("\n")
    .map {|i| 
      _, name, weight, children = /^(\w+) \((\d+)\)(?: -> (.+))?/.match(i).to_a
      children = children.nil? ? [] : children.split(', ').map(&:to_sym)
      {name: name.to_sym, weight: weight.to_i, children: children}
    }
    .reduce({}) {|accum, i| accum[i[:name]] = i; accum}
end

def build_tree(flat_tree)
  while flat_tree.keys.size > 1
    flat_tree.each do |k, v|
      
      next if v[:children].any? {|a| a.is_a?(Symbol)}
      
      flat_tree.each do |ck, cv|
        next if ck == k
        
        idx = cv[:children].index(k)
        next if idx.nil?
        # binding.pry
        cv[:children][idx] = v
        flat_tree.delete(k) 
        break
      end
    end
  end
  
  flat_tree[flat_tree.keys.first]
end

def calculate_weight(node)
  weight = node[:weight]
  
  weight += node[:children].map {|i| 
    calculate_weight(i)
  }
  .sum
  
  weight
end

def child_weights(node)
  weights = []
  node[:children].each do |n|
    weights << calculate_weight(n)
  end
  weights
end

def find_unbalanced_node(node, parent=nil, parent_weights=nil)
  weights = []
  node[:children].each do |n|
    weights << calculate_weight(n)
  end
  
  uw = weights.uniq
  if uw.size > 1
    # Tree is unbalanced
    
    # just gross
    first = weights.count(uw[0])
    second = weights.count(uw[1])
    
    idx = first > second ? weights.index(uw[1]) : weights.index(uw[0])
    find_unbalanced_node(node[:children][idx], node, weights)  
  else 
    [node, parent_weights]
  end
end

def weight_to_balance(node)
  unbal_node, parent_weights = find_unbalanced_node(node)
  unbal_node[:weight] - (parent_weights.max - parent_weights.min)
end



puts "\n  Part One"
puts "(exp == act)\n"

test_input = <<~INPUT
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
INPUT


test_input_tree = build_tree(parse_input(test_input))
puts "Test Case: tknk == #{test_input_tree[:name]}"

tree = build_tree(parse_input(puzzle_input))
puts "Solution: #{tree[:name]}"


puts "\n\n  Part Two"
puts "(exp == act)\n"

puts "Test Case: 60 == #{weight_to_balance(test_input_tree)}"
puts "Solution: #{weight_to_balance(tree)}"