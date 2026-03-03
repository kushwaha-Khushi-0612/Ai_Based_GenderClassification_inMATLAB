function displayAccuracyMetrics(accuracy, ax)
% Display accuracy metrics
% Inputs:
%   accuracy - Classification accuracy
%   ax - Axes handle for plotting

    % Create a bar chart showing accuracy with better colors
    b = bar(ax, [accuracy, 1-accuracy]);
    b.FaceColor = 'flat';
    b.CData(1,:) = [0 0.6 0.4];  % Green for accuracy
    b.CData(2,:) = [0.9 0.3 0.3];  % Red for error
    
    set(ax, 'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'Box', 'on');
    set(ax, 'XTickLabel', {'Accuracy', 'Error'});
    set(ax, 'FontSize', 10, 'TickLabelColor', 'black');
    ylabel(ax, 'Percentage', 'FontSize', 10, 'FontWeight', 'bold', 'Color', 'black');
    title(ax, sprintf('Model Accuracy: %.2f%%', accuracy*100), ...
          'FontSize', 11, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    ylim(ax, [0 1]);
    grid(ax, 'on');
    set(ax, 'GridLineStyle', ':', 'GridColor', [0.5 0.5 0.5], 'GridAlpha', 0.3);
    
    % Add percentage labels on bars with better styling
    text(ax, 1, accuracy, sprintf('%.2f%%', accuracy*100), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 11, ...
        'FontWeight', 'bold', ...
        'Color', [0 0.4 0.2]);
    
    text(ax, 2, 1-accuracy, sprintf('%.2f%%', (1-accuracy)*100), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 11, ...
        'FontWeight', 'bold', ...
        'Color', [0.6 0 0]);
end
