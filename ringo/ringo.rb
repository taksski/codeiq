# -*- coding: utf-8 -*-
require 'tree'

def prepare_leaves(table, num_symbols)
  leaves = table.map { |node| Tree::TreeNode.new(node[0], node.dup.push('')) }
  #出現頻度0のダミーの葉ノードを必要に応じて追加する
  #(生成する符号を最適化するための処理)
  n = 0
  while (leaves.size%(num_symbols-1) != 1)
    leaves.push Tree::TreeNode.new("dummy#{n}", ["dummy#{n}",0,''])
    n += 1
  end if num_symbols != 2
  leaves
end

def create_subtree(name, nodes, symbols)
  sym = symbols.dup
  new_node = Tree::TreeNode.new(name,[name,0,''])
  nodes.each do |node|
    new_node << node
    new_node.content[1] += node.content[1]
    node.content[2] = sym.shift
  end
  new_node
end

def get_code(node)
  return '' if node.is_root?
  get_code(node.parent) + node.content[2]
end

def n_huffman(table, symbols)
  nodes = prepare_leaves(table, symbols.size).
    sort { |a,b| b.content[1] <=> a.content[1] }
  n = 0
  until nodes.size == 1
    nodes1 = nodes.pop symbols.size
    new_node = create_subtree("node#{n}", nodes1, symbols)
    nodes = (nodes.push new_node).sort { |a,b| b.content[1] <=> a.content[1] }
    n += 1
  end
  result= []
  nodes[0].each_leaf { |node|
    result << [node.content[0], get_code(node), node.content[1]] if /dummy/ !~ node.name
  }
  nodes[0].print_tree
  result.sort { |a,b| a[0] <=> b[0] }
end

alphabet = {}
open(ARGV[0]) do |file|
  file.gets.split('').each do |c|
    if alphabet.key?(c) 
      alphabet[c] += 1
    else
      alphabet[c] = 1
    end
  end
end
alphabet_list = alphabet.flatten(0)
symbols = ['r','b','g']
codec = n_huffman(alphabet_list, symbols)
codec.each { |node| puts "#{node[0]}:#{node[1]}" }
puts
puts "version1のリンゴの数: #{codec.inject(0) { |sum, node| sum += node[2]*3 }}"
puts "version2のリンゴの数: #{codec.inject(0) { |sum, node| sum += node[2]*node[1].size }}"
