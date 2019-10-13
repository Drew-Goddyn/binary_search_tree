# Binary Search tree in Ruby
This is my implementation of a binary search tree in ruby.
This implemtation creates a balanced tree where all left children are less than the root node and all right children are greater. E.g.

```
       _9_
     _/   \_
  _4_       _15_
 /   \     /    \
2     6   12    17
```

## usage
Pass an array to create a new tree:
```
tree = BinarySearchTree.new([12,2,6,4,9,15,17])
```
Insert or delete elements by value:
```
tree.insert(18)

       _9_
     _/   \_
  _4_       _15_
 /   \     /    \
2     6   12    17_
                   \
                   18

tree.delete(15)
```


