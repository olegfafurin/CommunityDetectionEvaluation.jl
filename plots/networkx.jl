using BenchmarkTools
using Graphs
using Plots
using PythonCall

nx = pyimport("networkx")

function to_networkx(g::AbstractGraph)
    h = nx.Graph()
    for v in vertices(g)
        h.add_node(v - 1)
    end
    for e in edges(g)
        h.add_edge(src(e) - 1, dst(e) - 1)
    end
    return h
end

function measure_time_python(g::Py)
    @belapsed $(nx.community.greedy_modularity_communities)($g) seconds=1 evals=1
end

function measure_time_julia(g::AbstractGraph)
    @belapsed community_detection_greedy_modularity($g) seconds=1 evals=1
end

g_list = [complete_graph(n) for n in 1:10]
t_list = [measure_time_julia(g) for g in g_list]
pl = scatter(1:10, t_list; ylim=(0, Inf), label="julia")

g_py_list = [nx.complete_graph(n) for n in 2:10]
t_py_list = [measure_time_python(g) for g in g_py_list]
scatter!(pl, 2:10, t_list; ylim=(0, Inf), label="python")

g_py = nx.karate_club_graph()
c = nx.community.greedy_modularity_communities(g_py)
pyconvert(Vector, c[0])

g = SimpleGraph(10, 20)
to_networkx(g)
