require './node.rb'

class NodeNotFound < StandardError
  def initialize(value)
    @value = value
  end
  def message
    "There is no node in tree with a value of '#{@value.inspect}'"
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


  [:inorder,:preorder,:postorder].each do |traversal_mode|
    left_method = "traverse_#{traversal_mode}(node.left, &block)"
    right_method = "traverse_#{traversal_mode}(node.right, &block)"
    blok = "block.call(node)"

    traversal_methods = {
      inorder:    [left_method, blok, right_method],
      preorder:   [blok, left_method, right_method],
      postorder:  [left_method, right_method, blok],
    }

    define_method :"traverse_#{traversal_mode}_meta" do |node = root, &block|
      return if node.nil?

      traversal_methods[traversal_mode].each{ |method| eval(method) }
      return
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

  def is_balanced?
    left_depth = depth(root.left)
    right_depth = depth(root.right)
    (left_depth - right_depth).abs < 1
  end

  def print_dump
    print_proc = Proc.new do |node|
      print "#{node.data} "
    end

    puts "#{traverse_levelorder_recursive(&print_proc)} - levelorder recursive"
    puts "#{traverse_levelorder_iterative(&print_proc)} - levelorder iterative"
    puts "#{traverse_inorder(&print_proc)} - inorder"
    puts "#{traverse_inorder_meta(&print_proc)} - inorder_meta"
    puts "#{traverse_preorder(&print_proc)} - preorder"
    puts "#{traverse_preorder_meta(&print_proc)} - preorder_meta"
    puts "#{traverse_postorder(&print_proc)} - postorder"
    puts "#{traverse_postorder_meta(&print_proc)} - postorder_meta"
  end
end

### A driver to show functionality since I was too lazy to rspec it...
puts
array = [1,7,4,23,8,9,4,3,5,7,9,67,6345,324,6344]
puts "Creating balanced tree from array: #{array.inspect}"
puts
tree = BinarySearchTree.new(array)

tree.print_dump
puts
puts "Checking if tree is balanced: #{tree.is_balanced?}"
puts "Unbalancing the tree..."
tree.insert(22)
tree.insert(5235)
tree.insert(233)
tree.insert(451)
tree.insert(29)
tree.insert(92)
tree.insert(45)
tree.insert(511)
puts "Checking if tree is balanced: #{tree.is_balanced?}"
puts
tree.print_dump
puts
puts "Rebalancing tree..."
tree.rebalance!
puts "checking if tree is balanced: #{tree.is_balanced?}"
puts
tree.print_dump


