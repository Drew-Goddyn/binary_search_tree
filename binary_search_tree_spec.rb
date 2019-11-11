require "./binary_search_tree.rb"
require "pry"

RSpec.describe BinarySearchTree do

  def isBST?(node, mini = -4294967296, maxi = 4294967296)
    return true unless node
    # False if this node violates min/max constraint
    return False if node.data < mini or node.data > maxi
    # Otherwise check the subtrees recursively tightening the min or max constraint
    return isBST?(node.left, mini, node.data - 1) && isBST?(node.right, node.data + 1, maxi)
  end

  let (:test_input) { [6345, 1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 324, 6344] }
  subject { described_class.new(test_input) }

  it "is a binary search tree" do
    expect(isBST?(subject.root)).to eq(true)
  end

  it "creates a balanced tree" do
    expect(subject.root.data).to eq(8)
    expect(subject.balanced?).to eq(true)
  end

  describe "#insert" do
    it "raise error when inserting duplicates" do
      expect{subject.insert(3)}.to raise_error(DuplicateInsertion)
    end

    it "inserts correctly" do
      subject.insert(2)
      expect(subject.find(2)).to be_truthy
      (10..20).each{ |n| subject.insert(n)}
      expect(isBST?(subject.root)).to eq(true)
    end
  end

  describe "#delete" do
    context "when node is a leaf" do
      it "deletes node" do
        subject.delete(23)
        expect(subject.levelorder_recursive).to eq([8, 4, 67, 1, 5, 9, 6344, 3, 7, 324, 6345])
        expect(isBST?(subject.root)).to eq(true)
      end
    end
    context "when node has one child" do
      it "replaces node with child" do
        subject.delete(9)
        expect(subject.levelorder_recursive).to eq([8, 4, 67, 1, 5, 23, 6344, 3, 7, 324, 6345])
        expect(isBST?(subject.root)).to eq(true)
      end
    end
    context "when node has two children" do
      it "replaces node with inorder successor" do
        subject.delete(67)
        expect(subject.levelorder_recursive).to eq([8, 4, 324, 1, 5, 9, 6344, 3, 7, 23, 6345])
        expect(isBST?(subject.root)).to eq(true)
      end
    end
  end

  describe "#find" do
    it "raises error if node not found" do
      expect{subject.find(9999)}.to raise_error(NodeNotFound)
    end

    it "finds a node" do
      node = subject.find(4)
      expect(node.data).to eq(4)
      expect(node.left.data).to eq(1)
      expect(node.right.data).to eq(5)
    end
  end

  describe "#min_value_node" do
    it "returns min value node in tree" do
      expect(subject.min_value_node.data).to eq(1)
    end
  end

  describe "#max_value_node" do
    it "returns max value node in tree" do
      expect(subject.max_value_node.data).to eq(6345)
      subject.insert(9999)
      expect(subject.max_value_node.data).to eq(9999)
    end
  end

  describe "#depth" do
    it "returns depth from given node" do
      expect(subject.depth).to eq(4)
      expect(subject.depth(subject.root.left)).to eq(3)
      expect(subject.depth(subject.root.right)).to eq(3)
      subject.insert(9998)
      subject.insert(9999)
      expect(subject.depth).to eq(6)
      expect(subject.depth(subject.root.left)).to eq(3)
      expect(subject.depth(subject.root.right)).to eq(5)
    end
  end

  context "balancing" do
    let (:unbalanced_tree) do 
      described_class.new(test_input).tap{ |tree| (9990..9999).each{ |n| tree.insert(n) } }
    end
    describe "#balanced?" do
      it "returns true when tree balanced" do
        expect(subject.balanced?).to eq(true)
      end
      it "returns false when tree unbalanced" do
        expect(unbalanced_tree.balanced?).to eq(false)
      end
    end

    describe "#rebalance" do
      it "rebalances a tree" do
        unbalanced_tree.rebalance!
        expect(unbalanced_tree.balanced?).to eq(true)
        expect(unbalanced_tree.root.data).to eq(6344)
        expect(isBST?(subject.root)).to eq(true)
      end
    end
  end

  describe "traversal methods" do
    shared_examples "a traversal method" do |traversal_methods, expected_output|
      traversal_methods.each do |traversal_method|
        it "traverses correctly" do
          expect(subject.send(traversal_method)).to eq(expected_output)
        end
        it "yields a block" do
          output = []
          proc = Proc.new{ |node| output << node.data }
          subject.send(traversal_method, &proc)
          expect(output).to eq(expected_output)
        end
      end
    end

    describe "#levelorder" do
      levelorder_expected = [8, 4, 67, 1, 5, 9, 6344, 3, 7, 23, 324, 6345]
      methods = [:levelorder_iterative, :levelorder_recursive]
      it_should_behave_like "a traversal method", methods, levelorder_expected
    end

    describe "#inorder" do
      inorder_expected = [1, 3, 4, 5, 7, 8, 9, 23, 67, 324, 6344, 6345]
      it_should_behave_like "a traversal method", [:inorder], inorder_expected
    end

    describe "#preorder" do
      preorder_expected = [8, 4, 1, 3, 5, 7, 67, 9, 23, 6344, 324, 6345]
      it_should_behave_like "a traversal method", [:preorder], preorder_expected
    end

    describe "#postorder" do
      postorder_expected = [3, 1, 7, 5, 4, 23, 9, 324, 6345, 6344, 67, 8]
      it_should_behave_like "a traversal method", [:postorder], postorder_expected
    end
  end
end