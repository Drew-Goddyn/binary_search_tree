require 'pry'

class NodeNotFound < StandardError
    def initialize(value)
      @value = value
    end
    def message
      "There is no node in tree with a value of '#{@value.inspect}'"
    end
end

class Node
  include Comparable
  attr_accessor :data, :parent, :left, :right
  def initialize(data)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    data <=> other.data
  end

  def leaf?
    left.nil? && right.nil?
  end

  def single_parent?
    left.nil? && !right.nil? || !left.nil? && right.nil?
  end
end

class BinarySearchTree
  attr_reader :root
  def initialize(array)
    array.sort!
    array.uniq!
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.empty?

    root_index = (array.size - 1) / 2
    root_node = Node.new(array[root_index])
    root_node.left = build_tree(array[0...root_index])
    root_node.right = build_tree(array[root_index+1..-1])
    root_node
  end

  def insert(value, node = root)
    node = Node.new(value) if node.nil?
    if value < node.data
      if node.left.nil?
        node.left = Node.new(value)
      else
        insert(value, node.left)
      end
    else
      if node.right.nil?
        node.right = Node.new(value)
      else
        insert(value, node.right )
      end
    end

  end

  def delete(value, node = root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      if node.leaf?
        return nil
      elsif node.single_parent?
        return node.left || node.right
      end
      temp = min_value_node(node.right)
      node.data = temp.data
      node.right = delete(temp.data, node.right)
    end
    node
  end

  def traverse_levelorder_recursive(current = root, queue = [], &block)
    return if current.nil?

    block.call(current)
    queue << current.left if current.left
    queue << current.right if current.right
    current = queue.shift
    traverse_levelorder_recursive(current, queue, &block)
  end

  def traverse_levelorder_iterative(start_node = root)
    queue = [start_node]
    until queue.empty?
      current = queue.shift
      yield(current)
      queue << current.left if current.left
      queue << current.right if current.right
    end
  end

  def traverse_inorder(node = root, &block)
    return if node.nil?

    traverse_inorder(node.left, &block)
    block.call(node)
    traverse_inorder(node.right, &block)

  end

  def traverse_preorder(node = root, &block)
    return if node.nil?

    block.call(node)
    traverse_preorder(node.left, &block)
    traverse_preorder(node.right, &block)
  end

  def traverse_postorder(node = root, &block)
    return if node.nil?

    traverse_postorder(node.left, &block)
    traverse_postorder(node.right, &block)
    block.call(node)
  end

  def find(value, node = root)
    raise NodeNotFound.new(value) if node.nil?
    return node if node.data == value

    if value < node.data
      find(value, node.left)
    else
      find(value, node.right)
    end
  end

  def min_value_node(node = root)
    current = node

    until current.left.nil?
      current = current.left
    end
    current
  end

  def max_value_node(node = root)
    current = node
    until current.right.nil?
      current = current.right
    end
    current
  end

  def rebalance!
    array = []
    traverse_levelorder_iterative {|node| array << node.data}
    array.sort!
    @root = build_tree(array)
  end

  def length
    count = 0
    traverse_levelorder_iterative {count +=1 }
    count
  end

  def depth(node = root)
    if node.nil?
      return 0
    else
      left_depth = depth(node.left)
      right_depth = depth(node.right)

      if (left_depth > right_depth)
        left_depth+1
      else
        right_depth+1
      end
    end
  end
end

array = [1,7,4,23,8,9,4,3,5,7,9,67,6345,324,6344]
# 50.times{ array << rand(1..1000)}
# array = [2, 5, 1, 3, 4]
tree = BinarySearchTree.new(array)
tree.insert(22)
tree.insert(5235)
tree.insert(233)
tree.insert(451)
tree.insert(29)
tree.insert(92)
tree.insert(45)
tree.insert(511)
print_proc = Proc.new do |node|
  print "#{node.data} "
end

puts "levelorder recursive:"
puts tree.traverse_levelorder_recursive(&print_proc)
puts "levelorder iterative:"
puts tree.traverse_levelorder_iterative(&print_proc)
puts "inorder:"
puts tree.traverse_inorder(&print_proc)
puts "preorder:"
puts tree.traverse_preorder(&print_proc)
puts "postorder:"
puts tree.traverse_postorder(&print_proc)
binding.pry
tree.depth
tree.delete(5)
# tree.rebalance!

=begin
print_tree
#rebalance
#height(node)
#width(level)
#rebalance
=end
