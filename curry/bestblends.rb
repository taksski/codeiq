# -*- coding: utf-8 -*-
load 'lib/graph.rb'
load 'lib/graph/node.rb'

debug = 0

def min_cut(graph)
  # カット数の初期値を枝の数として、すべての頂点が片方のカットに
  # 含まれる候補を作成する。
  # (扱うのは無向グラフなので見かけの枝の数の半分が実際の枝の数)
  candidate = [graph.nodes.map{|node|node.name}.flatten.sort,
               [],
               graph.nodes.inject(0){|sum, node|
                 sum += node.neighbors_weight
               }/2
              ]
  until graph.nodes.size == 1
    graph.sort_by_maximum_adjacency_ordering
    if graph.nodes[-1].neighbors_weight < candidate[2] # 候補となる頂点の組の入れ替え
      candidate = [graph.nodes[0..-2].map{ |n| n.name }.flatten.sort,
                   [graph.nodes[-1].name].flatten.sort,
                   graph.nodes[-1].neighbors_weight
                  ]
    end
    graph.merge(graph.nodes[-2].name, graph.nodes[-1].name) # 末尾の2頂点を結合
  end
  candidate
end

graph = Graph.new

ARGF.each { |l|
  /([A-Za-z]+)\s+([A-Za-z]+)/ =~ l
  name1 = $1
  name2 = $2
  graph.add_edge(name1, name2)
}

cut_set = min_cut(graph)
if (cut_set[0].count > cut_set[1].count)
  puts cut_set[0].join(' ')
else
  puts cut_set[1].join(' ')
end
