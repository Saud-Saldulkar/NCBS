function plot_returncount_greybar(returns_index)
% output grey bars of return count index
    whitebg([0.5,0.5,0.5]);
    bar(returns_index, 'k')

    xlim([0 7000]);
    ylim([0 1]);

    set(gca, 'ytick', []);
    set(gca, 'xtick', []);
    set(gcf, 'Position', [1,1,1000,25]);
end