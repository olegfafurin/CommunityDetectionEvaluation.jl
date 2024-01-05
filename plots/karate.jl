using Graphs
using Plots


g = smallgraph(:karate)
c, qs = community_detection_greedy_modularity(g, weights=BigFloat.(weights(g)))
i = argmax(qs)


p1 = plot(
    1:nv(g),
    qs,
    title="Modularity evolution in karate club graph",
    titlefontsize=11,
    label="Q",
    xlims=(0, 37),
    ylims=(-0.075, 0.45),
    xticks=[0:5:35; i],
    yticks=[0.0:0.1:0.4; round(qs[i], digits=2)],
    xlabel="number of steps of the algorithm",
    xlabelfontsize=9,
    ylabel="modularity value",
    ylabelfontsize=9,
)

scatter!(p1, [i], [qs[i]], label="Q_max")

savefig(p1, "karate.png")
# scatter!(p1, 1:nv(g), qs, size)