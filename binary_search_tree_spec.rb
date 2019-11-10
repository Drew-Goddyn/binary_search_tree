require "./binary_search_tree.rb"
require "pry"

RSpec.describe BinarySearchTree do

  def isBST?(node, mini = -4294967296, maxi = 4294967296)
    return true unless node
    # False if this node violates min/max constraint
    return False if node.data < mini or node.data > maxi
    # Otherwise check the subtrees recursively
    # tightening the min or max constraint
    return isBST?(node.left, mini, node.data - 1) && isBST?(node.right, node.data + 1, maxi)
  end

  let (:test_input)        { [6345, 1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 324, 6344] }
  let (:levelorder_expected) { [8, 4, 67, 1, 5, 9, 6344, 3, 7, 23, 324, 6345] }
  let (:inorder_expected)    { [1, 3, 4, 5, 7, 8, 9, 23, 67, 324, 6344, 6345] }
  let (:preorder_expected)   { [8, 4, 1, 3, 5, 7, 67, 9, 23, 6344, 324, 6345] }
  let (:postorder_expected)  { [3, 1, 7, 5, 4, 23, 9, 324, 6345, 6344, 67, 8]}

  subject {described_class.new(test_input)}

  it "is a binary search tree" do
    expect(isBST?(subject.root)).to eq(true)
  end

  it "only accepts arrays of numeric values" do
      expect{ described_class.new("1") }.to raise_error(ArgumentError)
      expect{ described_class.new(1) }.to raise_error(ArgumentError)
      expect{ described_class.new({first:1}) }.to raise_error(ArgumentError)
      expect{ described_class.new(["1", 2]) }.to raise_error(ArgumentError)
  end

  it "creates a balanced tree" do
    expect(subject.root.data).to eq(levelorder_expected.first)
    expect(subject.balanced?).to eq(true)
  end

  # describe "#initialize" do
  #   it "errors when not passed an Array" do
  #     expect{described_class.new("1")}.to raise_error(ArgumentError)
  #     expect{described_class.new(1)}.to raise_error(ArgumentError)
  #     expect{described_class.new({first:1})}.to raise_error(ArgumentError)
  #     expect{described_class.new("1") }.to raise_error(ArgumentError)
  #   end

  #   it "errors when array includes non-numeric values" do
  #     expect{described_class.new(["1", 2])}.to raise_error(ArgumentError)
  #   end

  #   it "calls #build_tree with a de-duped sorted array" do
  #     expect_any_instance_of(described_class).to receive(:build_tree).with(test_input.sort.uniq)
  #     described_class.new(test_input)
  #   end
  # end

  # describe "#build_tree" do
  #   subject { described_class.new(test_input) }
  #   it "creates a balance tree" do
  #     middle_index = (test_input.size - 1) / 2]
  #     expect(subject.root).to eq(test_input[middle_index])
  #   end
  # end
end