function plotConfusionMatrix(confMat, ax)
% Plot confusion matrix
% Inputs:
%   confMat - Confusion matrix
%   ax - Axes handle for plotting

    if isempty(confMat)
        return;
    end
    
    % Normalize confusion matrix
    confMatNorm = confMat ./ sum(confMat, 2);
    
    % Plot with better colors
    imagesc(ax, confMatNorm);
    colormap(ax, parula);  % Modern colormap
    cb = colorbar(ax);
    set(cb, 'Color', [0 0 0]);
    set(ax, 'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'Box', 'on');
    
    % Set labels with better styling
    set(ax, 'XTick', 1:size(confMat, 1));
    set(ax, 'YTick', 1:size(confMat, 1));
    set(ax, 'XTickLabel', {'Female', 'Male'});
    set(ax, 'YTickLabel', {'Female', 'Male'});
    set(ax, 'FontSize', 9, 'TickLabelColor', 'black');
    xlabel(ax, 'Predicted Class', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'black');
    ylabel(ax, 'True Class', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'black');
    title(ax, 'Confusion Matrix', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    
    % Add text annotations
    for i = 1:size(confMat, 1)
        for j = 1:size(confMat, 2)
            text(ax, j, i, sprintf('%d\n(%.1f%%)', confMat(i,j), confMatNorm(i,j)*100), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', ...
                'Color', 'white', ...
                'FontSize', 9, ...
                'FontWeight', 'bold');
        end
    end
end
