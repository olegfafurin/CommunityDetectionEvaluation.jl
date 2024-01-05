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

g_py_trivial = nx.Graph([(0,1)])
python_call_time = @belapsed $(nx.community.greedy_modularity_communities)($g_py_trivial) evals=1

function measure_time_python(g::Py)
    time = (@belapsed $(nx.community.greedy_modularity_communities)($g) seconds=1 evals=1) - python_call_time
    GC.gc()
    return time
end

function measure_time_julia(g::AbstractGraph)
    time = @belapsed $(community_detection_greedy_modularity)($g) seconds=1 evals=1
    GC.gc()
    return time
end

g_list = [stochastic_block_model(10, 1, [n ÷  2, n ÷ 2]) for n in  2 .^ (5:12)]
t_list = [measure_time_julia(g) for g in g_list]
pl = scatter(2 .^(5:12), t_list; title="Comparison of execution time for greedy algorithm implementations", titlefontsize=9, label="julia", xaxis=:log, xlabel="number of nodes", xlabelfontsize=10, ylabel="time, s", ylabelfontsize=10)

g_py_list = [to_networkx(g) for g in g_list]
t_py_list = [measure_time_python(g) for g in g_py_list]
scatter!(pl, 2 .^(5:12), t_py_list; ylim=(0, 25), label="python", yaxis=:log, xaxis=:log)

# todo fix axis scale, maybe boxplot?

savefig(pl, "julia_v_python.png")

println(t_list)
println(t_py_list)
