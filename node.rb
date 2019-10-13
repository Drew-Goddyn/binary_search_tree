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