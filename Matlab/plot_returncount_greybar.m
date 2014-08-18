function plot_returncount_greybar(returns_index)
    whitebg([0.9,0.9,0.9]);
    bar(returns_index, 'k')
    
    
    xlim([0 7000]);
    ylim([0 1]);

    set(gca, 'ytick', []);
    set(gca, 'xtick', []);
    set(gcf, 'Position', [1,1,1000,25]);

end