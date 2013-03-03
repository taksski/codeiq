# -*- coding: utf-8 -*-
class Graph
  
  attr :nodes
  
  def initialize
    @nodes=[]
  end

  def to_s
    "##<Graph:0x#{self.object_id.to_s(16)} #{@nodes.each { |n| n.to_s }}>"
  end

  def add_edge(name1, name2)
    node1 = @nodes.find {|n| n.name == name1}
    if (node1.nil?)
      node1 = Node.new(name1)
      @nodes.push node1
    end
    node2 = @nodes.find {|n| n.name == name2}
    if (node2.nil?)
      node2 = Node.new(name2)
      @nodes.push node2
    end
    node1.add_neighbor([name2, 1])
    node2.add_neighbor([name1, 1])
  end

  def merge(dst, src)
    dst_node = @nodes.find { |n| n.name == dst }
    src_node = @nodes.find { |n| n.name == src }
    return if (dst_node.nil? or src_node.nil?)
    dst_node.name = [dst, src].flatten.sort
    dst_node.merge_neighbors([dst, src])
    src_node.merge_neighbors([dst, src])
    dst_node.neighbors.each { |dst_neighbor|
      src_neighbor = src_node.neighbors.assoc(dst_neighbor[0])
      unless src_neighbor.nil?
        dst_neighbor[1] += src_neighbor[1]
        src_node.neighbors.delete_if { |other_neighbor|
          dst_neighbor[0] == other_neighbor[0]
        }
      end
    }
    dst_node.neighbors += src_node.neighbors
    dst_node.neighbors.delete_if { |neighbor| neighbor[0] == dst_node.name }
    @nodes.each { |node|
      dst_node.neighbors.each { |neighbor|
        if node.name == neighbor[0]
          node.merge_neighbors([dst, src])
        end
      }
    }
    @nodes.delete_if { |n| n.name == src }
  end

  def sort_by_maximum_adjacency_ordering
    result = []
    result.push @nodes.pop
    while @nodes.count > 0
      names = result.map { |node| node.name }
      nearest = nearest_neighbor(names)
      result.push put_nearest_neighbor(names)
      @nodes.delete_if { |node| node.name == nearest.name }
    end
    @nodes = result
  end

  private
  # 名前の配列に対して、もっとも結合度が大きい頂点を返す
  def nearest_neighbor(names)
    @nodes.max { |a, b|
      a_weight = a.neighbors_weight(names)
      b_weight = b.neighbors_weight(names)
      if (a_weight > b_weight) then 1
      elsif a_weight == b_weight then 0
      else -1
      end
    }
  end

end

=begin

graph.rb --- グラフを表す

属性
   nodes lib/node.rbで定義したNodesで表される頂点を要素に持つ配列

メソッド
   add_edge 指定した名前の頂点間に隣接度1の枝を張る。
            頂点がなければ、新たに作成して追加する。
   merge    指定した2つの名前の頂点を結合する。
            結合した頂点に隣接する頂点間の枝の結合度は、それぞれ加算する。
   sort_by_maximum_adjacency_ordering
            nodesの末尾の頂点を基準として、最大隣接順序を満たすように
            頂点を並べ直す。

=end
