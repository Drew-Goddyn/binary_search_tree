require_relative './node.rb'

class NodeNotFound < StandardError;end
class DuplicateInsertion < StandardError;end

class BinarySearchTree
  attr_reader :root

  def initialize(array)
    array = Array(array)
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
    raise DuplicateInsertion, "#{value} already exists in Tree" if node.data == value

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
    self
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



  def levelorder_recursive(current = root, queue = [], result = [], &block)
    return if current.nil?

    block_given? ? block.call(current) : result << current.data
    queue << current.left if current.left
    queue << current.right if current.right
    current = queue.shift
    levelorder_recursive(current, queue, result, &block)
    result unless block_given?
  end

  def levelorder_iterative(start_node = root, result = [])
    queue = [start_node]
    until queue.empty?
      current = queue.shift
      block_given? ? yield(current) : result << current.data
      queue << current.left if current.left
      queue << current.right if current.right
    end
    result unless block_given?
  end

  def inorder(node = root, result = [], &block)
    return if node.nil?

    inorder(node.left, result, &block)
    block_given? ? block.call(node) : result << node.data
    inorder(node.right, result, &block)
    result unless block_given?
  end

  def preorder(node = root, result = [], &block)
    return if node.nil?

    block_given? ? block.call(node) : result << node.data
    preorder(node.left, result, &block)
    preorder(node.right, result, &block)
    result unless block_given?
  end

  def postorder(node = root, result = [], &block)
    return if node.nil?

    postorder(node.left, result, &block)
    postorder(node.right, result, &block)
    block_given? ? block.call(node) : result << node.data
    return result unless block_given?
  end

  def find(value, node = root)
    raise NodeNotFound, "#{value} isn't in Tree" if node.nil?
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

  def rebalance!
    array = []
    levelorder_iterative {|node| array << node.data}
    array.sort!
    @root = build_tree(array)
  end

  def balanced?
    left_depth = depth(root.left)
    right_depth = depth(root.right)
    (left_depth - right_depth).abs < 1
  end

  def pretty_print(node = root, prefix="", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? "│   " : "    "}", false) if node.right
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.data.to_s}"
    pretty_print(node.left, "#{prefix}#{is_left ? "    " : "│   "}", true) if node.left
  end

  def print_dump
    print_proc = Proc.new do |node|
      print "#{node.data} "
    end

    puts "#{levelorder_recursive(&print_proc)} - levelorder recursive"
    puts "#{levelorder_iterative(&print_proc)} - levelorder iterative"
    puts "#{inorder(&print_proc)} - inorder"
    puts "#{inorder_meta(&print_proc)} - inorder_meta"
    puts "#{preorder(&print_proc)} - preorder"
    puts "#{preorder_meta(&print_proc)} - preorder_meta"
    puts "#{postorder(&print_proc)} - postorder"
    puts "#{postorder_meta(&print_proc)} - postorder_meta"
  end
end
