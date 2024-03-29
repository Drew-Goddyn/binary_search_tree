# Binary Search tree in Ruby
This is my implementation of a binary search tree in ruby.
It creates a balanced tree where all left children are less than the root node and all right children are greater. E.g.

```
│       ┌── 17
│   ┌── 15
│   │   └── 12
└── 9
    │   ┌── 6
    └── 4
        └── 2
```

## Why?
BST's might be useful in situations where you need the benefits of both a linked list and `Array#bsearch`. A situation where you are able to sort once, frequently need to search for a value, and frequently need to insert elements into the middle.

But lets be honest, in most scenarios you should probably just use a hash.

## How to use it

### Input will be cast to an array on initialization and must be sortable:
#### Bad:

```Ruby
BinarySearchTree.new([1,"2"]) #=> ArgumentError: comparison of Integer with String failed
```

#### Good:
```Ruby
BinarySearchTree.new(5)
BinarySearchTree.new({a:1,b:2})
BinarySearchTree.new((1..100))
BinarySearchTree.new([12,2,6,4,9,15,17])
```

### Insert or delete elements by value:
```Ruby
tree = BinarySearchTree.new([12,2,6,4,9,15,17])
```

```Ruby
tree.insert(16):
tree.pretty_print

│       ┌── 17
│       │   └── 16
│   ┌── 15
│   │   └── 12
└── 9
    │   ┌── 6
    └── 4
        └── 2
```

```Ruby
tree.delete(15)
tree.pretty_print

│       ┌── 17
│   ┌── 16
│   │   └── 12
└── 9
    │   ┌── 6
    └── 4
        └── 2
```

### Rebalance a tree that has become unbalanced:

```Ruby
tree = BinarySearchTree.new([12,2,6,4,9,15,17])
tree.insert(56)
tree.insert(22)
tree.insert(18)
tree.balanced? #=> false
```

```
tree.pretty_print

│           ┌── 56
│           │   └── 22
│           │       └── 18
│       ┌── 17
│   ┌── 15
│   │   └── 12
└── 9
    │   ┌── 6
    └── 4
        └── 2
```

```Ruby
tree.rebalance!
tree.balanced? #=> true
```

```
tree.pretty_print

│           ┌── 56
│       ┌── 22
│   ┌── 18
│   │   │   ┌── 17
│   │   └── 15
└── 12
    │       ┌── 9
    │   ┌── 6
    └── 4
        └── 2
```

### Find a node
```Ruby
tree = BinarySearchTree.new([12,2,6,4,9,15,17])
tree.find(15) #=> <Node:0x00007f7fcbd417f8 @data=15, @left=#<Node:0x00007f7fcbd41780 @data=12, @left=nil, @right=nil>, @right=#<Node:0x00007f7fcbd41668 @data=17, @left=nil, @right=nil>>
```


### Traversal
Traverse using any of the common traversal methods
```
#levelorder_recursive
#levelorder_iterative
#inorder
#preorder
#postorder
```

Calling a traversal method will return an array of node data
```Ruby
tree.levelorder_recursive #=> [9, 4, 15, 2, 6, 12, 17]
tree.inorder #=> [2, 4, 6, 9, 12, 15, 17]
tree.preorder #=> [9, 4, 2, 6, 15, 12, 17]
tree.postorder #=>[2, 6, 4, 12, 17, 15, 9]
```

All traversal methods accept a block instead, allowing you to do whatever you want with each node while traversing. An example of printing all elements in the tree using the various algorithms can be seen by using `#print_dump`:
```Ruby
tree = BinarySearchTree.new([12,2,6,4,9,15,17])
tree.print_dump

29 7 324 3 9 67 5235 1 4 8 22 45 92 451 6344 5 23 233 511 6345  - levelorder recursive
29 7 324 3 9 67 5235 1 4 8 22 45 92 451 6344 5 23 233 511 6345  - levelorder iterative
1 3 4 5 7 8 9 22 23 29 45 67 92 233 324 451 511 5235 6344 6345  - inorder
29 7 3 1 4 5 9 8 22 23 324 67 45 92 233 5235 451 511 6344 6345  - preorder
1 5 4 3 8 23 22 9 7 45 233 92 67 511 451 6345 6344 5235 324 29  - postorder
```

An example of adding each element to an array inorder using a block:
```Ruby
tree = BinarySearchTree.new([12,2,6,4,9,15,17])
array = []
tree.inorder {|node| array << node.data}
puts array.inspect #=> [2, 4, 6, 9, 12, 15, 17]
```
