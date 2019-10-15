require "./node.rb"

RSpec.describe Node do
  it "initializes" do
    node = Node.new(5)
    expect(node.data).to eq(5)
  end

  it "compares nodes using data attribute" do
    small_node = Node.new(5)
    small_node2 = Node.new(5)
    big_node = Node.new(10)

    expect(small_node < big_node).to eq(true)
    expect(small_node == small_node2).to eq(true)
    expect(small_node > big_node).to eq(false)
  end

  it "is a leaf node when there are no children" do
    node = Node.new(5)
    expect(node.leaf?).to eq(true)
    expect(node.single_parent?).to eq(false)
  end

  it "is a single parent when there is a single child" do
    node = Node.new(5)
    node.left = Node.new(4)
    expect(node.leaf?).to eq(false)
    expect(node.single_parent?).to eq(true)
  end
end