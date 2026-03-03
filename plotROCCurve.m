function plotROCCurve(roc_data, ax)
% Plot ROC curve
% Inputs:
%   roc_data - Structure with FPR, TPR, and AUC
%   ax - Axes handle for plotting

    if isempty(roc_data)
        return;
    end
    
    plot(ax, roc_data.FPR, roc_data.TPR, 'Color', [0 0.4 0.7], 'LineWidth', 2.5);
    hold(ax, 'on');
    plot(ax, [0 1], [0 1], 'Color', [0.7 0.7 0.7], 'LineStyle', '--', 'LineWidth', 1.5); % Random classifier line
    fill(ax, [roc_data.FPR; 1; 0], [roc_data.TPR; 0; 0], [0.7 0.85 1], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    hold(ax, 'off');
    
    set(ax, 'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'Box', 'on');
    xlabel(ax, 'False Positive Rate', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'black');
    ylabel(ax, 'True Positive Rate', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'black');
    title(ax, sprintf('ROC Curve (AUC = %.4f)', roc_data.AUC), ...
          'FontSize', 11, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    grid(ax, 'on');
    set(ax, 'GridLineStyle', ':', 'GridColor', [0.5 0.5 0.5], 'GridAlpha', 0.3);
    xlim(ax, [0 1]);
    ylim(ax, [0 1]);
    legend(ax, {'ROC Curve', 'Random Classifier'}, 'Location', 'southeast', 'TextColor', [0 0 0]);
end
