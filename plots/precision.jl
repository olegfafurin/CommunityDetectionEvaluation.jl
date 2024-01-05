using Graphs
using Plots


function pred_precision(a::AbstractArray{Int}, b::AbstractArray{Int})
    return max(sum(a .== b), sum(a .== (3 .- b))) / length(a)
end


n_samples = 50
p = 0.4
q = 0.05
gs = [[stochastic_block_model((n ÷ 2 - 1) * p, (n ÷ 2 - 1) * q,[n ÷ 2, n ÷ 2]) for i in 1:n_samples] for n in 2 .^ (5:10)]

res = [community_detection_greedy_modularity.(g) for g in gs]
qs = [[ pred_precision(c_pred, [[1 for i=1:length(qs)÷2];[2 for i=1:length(qs)÷2]]) for (c_pred, qs) in graph_size] for graph_size in res]

pl = plot(
    title="Partitioning precision on SBM graphs with p=0.4, q=0.05", 
    titlefontsize=11,
    xlabel="number of nodes",
    xlabelfontsize=10,
    ylabel="precision",
    ylabelfontsize=10
)
for i in 1:6
    scatter!(
        pl,
        [2^(i + 4) for n in 1:n_samples], 
        qs[i],
        xaxis=:log,
        ylim=(0.9,1.03),
        label="n="*string(2^(i+4)),
        legend=false,
        )
end
plot(pl)
savefig(pl, "partitioning_precision_sbm.png")