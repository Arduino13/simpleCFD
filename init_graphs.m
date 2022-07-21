%initialization of graphs, this function is called not only during startup
%but also after changing simulation grid size
function [graph, graphH] = init_graphs(matrixDensity, densScale, graphPanel)
    graphLayout = tiledlayout(graphPanel, 2, 1);
    ax = nexttile(graphLayout);
    graph = quiver(ax,zeros(matrixDensity),zeros(matrixDensity));
    graph.AutoScale = 'off';
    xlim(ax, [0,matrixDensity]);
    ylim(ax, [0,matrixDensity]);
    close all; %quiver opens new window for to me uknown reason
        set(ax,'YDir','normal')

    ax = nexttile(graphLayout);
    graphH = imagesc(ax,zeros(matrixDensity),[1 densScale]);
    colormap(ax, turbo);
    set(ax,'YDir','normal')
end