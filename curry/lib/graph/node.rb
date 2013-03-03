# -*- coding: utf-8 -*-
class Node

  attr_accessor :name
  attr_accessor :neighbors

  def initialize(name)
    @name = name
    @neighbors = []
  end

  def ==(other)
    (@name == other.name) && (@neighbors == other.neighbors)
  end

  def add_neighbor(node)
    @neighbors.push node
    self
  end
  
  def neighbors_names
    @neighbors.map { |node| node[0] }
  end

  def neighbors_weight(names=[])
    if names == []
      @neighbors.inject(0) { |weights, neighbor|
        weights += neighbor[1]
      }
    else
      names.map { |name|
        neighbor = @neighbors.assoc(name)
        if neighbor.nil?
          0
        else
          neighbor[1]
        end
      }.inject(0) { |weights, weight| weights += weight }
    end
  end
  
  def merge_neighbors(neighbors)
    return if (neighbors.length != 2)
    dst = @neighbors.assoc(neighbors[0])
    src = @neighbors.assoc(neighbors[1])
    return if (dst.nil? && src.nil?)
    if (dst.nil?)
      src[0] = neighbors.flatten.sort
      return
    end
    dst[0] = neighbors.flatten.sort
    dst[1] += src[1] unless src.nil?
    @neighbors.delete_if { |n| n == src }
  end

end

=begin

node.rb --- グラフの頂点

属性
  name  頂点の名前
  neighbors [隣接する頂点の名前, 結合度]の組を要素に持つ配列

=end
