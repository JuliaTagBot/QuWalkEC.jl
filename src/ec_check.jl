"""
    function have_ss_connected(g::Graph, vertices::Vector{Int})

Checks whetever subgraph induced by `vertices` in `g` has stationary state.
Assumes `vertices` generates connected subgraph.
"""
function have_ss_connected(g::Graph, vertices::Vector{Int})
  ind_g, order = induced_subgraph(g, vertices)

  if length(vertices) == 1
    return false
  elseif length(vertices) == 2 #TODO remove after fixing bug in LightGraphs
    return degree(g, vertices[1]) == degree(g, vertices[2])
  end

  if is_bipartite(ind_g)
    bmap = bipartite_map(ind_g)
    v1 = find(x->x == 1, bmap)
    v2 = find(x->x == 2, bmap)
    return sum(degree(g, order[v1])) == sum(degree(g, order[v2]))
  else
    return true
  end
end


"""
    function have_ss_connected(g::Graph, vertices::Vector{Int})

Checks whetever all connected subgraphs induced by `vertices` in `g` have
stationary state.
"""
function have_ss(g::Graph, vertices::Vector{Int})

  subgraph, order = induced_subgraph(g, vertices)
  components = [order[vs] for vs=connected_components(subgraph)]
  all(have_ss_connected(g, vs) for vs=components)
end
