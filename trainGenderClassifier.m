function trainedNet = trainGenderClassifier(datasetPath, trainAxes, statusText, axAccuracy, axLoss)
% Train gender classifier using AlexNet transfer learning
% Inputs:
%   datasetPath - Path to dataset folder (contains male/ and female/ subfolders)
%   trainAxes - Cell array of axes for displaying training images
%   statusText - UI text control for status updates
%   axAccuracy - Axes for plotting training accuracy
%   axLoss - Axes for plotting training loss
% Output:
%   trainedNet - Trained network

    try
        %% Check if dataset exists
        if ~exist(datasetPath, 'dir')
            errordlg('Dataset folder not found! Please ensure dataset/male and dataset/female folders exist.', 'Error');
            trainedNet = [];
            return;
        end
        
        %% Load pre-trained AlexNet
        set(statusText, 'String', 'Loading AlexNet pre-trained model...');
        drawnow;
        
        % Try to load AlexNet with proper error handling
        try
            net = alexnet;
        catch
            % AlexNet not installed, try to prompt installation
            set(statusText, 'String', 'AlexNet not found! Installing...');
            drawnow;
            
            % Open Add-On Explorer for AlexNet
            msgbox({'AlexNet is required but not installed.', '', ...
                   'Click OK to open Add-On Explorer.', ...
                   'Search for "Deep Learning Toolbox Model for AlexNet Network"', ...
                   'and click Install.'}, 'AlexNet Required', 'help');
            
            matlab.addons.supportpackage.internal.explorer.showSupportPackages('deeplearning', 'alexnet');
            
            error('Please install AlexNet from Add-On Explorer and try again.');
        end
        
        %% Prepare image datastore
        set(statusText, 'String', 'Loading dataset...');
        drawnow;
        
        imds = imageDatastore(datasetPath, ...
            'IncludeSubfolders', true, ...
            'LabelSource', 'foldernames');
        
        % Check if dataset has both classes
        if numel(categories(imds.Labels)) < 2
            errordlg('Dataset must contain both male and female folders with images!', 'Dataset Error');
            trainedNet = [];
            return;
        end
        
        % Display dataset statistics
        labelCount = countEachLabel(imds);
        disp('Dataset Statistics:');
        disp(labelCount);
        
        %% Split data: 80% training, 20% validation
        [imdsTrain, imdsValidation] = splitEachLabel(imds, 0.8, 'randomized');
        
        set(statusText, 'String', sprintf('Training: %d images, Validation: %d images', ...
            numel(imdsTrain.Files), numel(imdsValidation.Files)));
        drawnow;
        
        %% Resize images to AlexNet input size with proper color handling
        inputSize = net.Layers(1).InputSize;
        
        % Create image augmenter for training data
        imageAugmenter = imageDataAugmenter( ...
            'RandRotation', [-20, 20], ...          % Random rotation up to 20 degrees
            'RandXReflection', true, ...            % Random horizontal flip
            'RandYReflection', false, ...           % No vertical flip (unnatural for faces)
            'RandXScale', [0.9, 1.1], ...          % Random horizontal scale
            'RandYScale', [0.9, 1.1]);             % Random vertical scale
        
        % Create augmented datastores with color preservation and augmentation
        % AlexNet expects RGB images with pixel values in [0, 255]
        augimdsTrain = augmentedImageDatastore(inputSize(1:2), imdsTrain, ...
            'DataAugmentation', imageAugmenter, ...
            'ColorPreprocessing', 'gray2rgb');  % Convert grayscale to RGB if needed
        augimdsValidation = augmentedImageDatastore(inputSize(1:2), imdsValidation, ...
            'ColorPreprocessing', 'gray2rgb');
        
        %% Modify AlexNet for binary classification
        set(statusText, 'String', 'Modifying network architecture for gender classification...');
        drawnow;
        
        layersTransfer = net.Layers(1:end-3);
        
        numClasses = numel(categories(imdsTrain.Labels));
        
        layers = [
            layersTransfer
            fullyConnectedLayer(numClasses, 'WeightLearnRateFactor', 20, 'BiasLearnRateFactor', 20)
            softmaxLayer
            classificationLayer];
        
        %% Set training options
        set(statusText, 'String', 'Configuring training options...');
        drawnow;
        
        % Check for GPU availability with error handling
        executionEnv = 'cpu';  % Default to CPU
        try
            if gpuDeviceCount > 0
                executionEnv = 'auto';  % Use GPU if available
                disp('GPU detected! Training will use GPU acceleration.');
            else
                disp('No GPU detected. Training will use CPU.');
            end
        catch
            % Parallel Computing Toolbox not available or GPU check failed
            disp('GPU check failed (Parallel Computing Toolbox may not be installed). Training will use CPU.');
        end
        
        options = trainingOptions('sgdm', ...
            'MiniBatchSize', 10, ...
            'MaxEpochs', 50, ...
            'InitialLearnRate', 3e-4, ...
            'Shuffle', 'every-epoch', ...
            'ValidationData', augimdsValidation, ...
            'ValidationFrequency', 3, ...
            'Verbose', false, ...
            'Plots', 'none', ...
            'ExecutionEnvironment', executionEnv, ...
            'OutputFcn', @(info) plotTrainingProgress(info, axAccuracy, axLoss, statusText));
        
        %% Train the network
        set(statusText, 'String', 'Training network... This may take several minutes...');
        drawnow;
        
        % Open training progress window
        trainingFig = figure('Name', 'Training Progress', ...
                            'NumberTitle', 'off', ...
                            'Position', [200 100 1120 650], ...
                            'Color', 'white', ...
                            'MenuBar', 'none');
        
        % Create axes for training progress in new window
        ax1 = subplot(2, 2, 1, 'Parent', trainingFig);
        set(ax1, 'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'Box', 'on', 'LineWidth', 1.5);
        title(ax1, 'Accuracy', 'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.04 0.52 0.78]);
        xlabel(ax1, 'Iteration', 'FontSize', 11, 'Color', 'black');
        ylabel(ax1, 'Accuracy (%)', 'FontSize', 11, 'Color', 'black');
        hold(ax1, 'on');
        grid(ax1, 'on');
        set(ax1, 'GridLineStyle', ':', 'GridColor', [0.7 0.7 0.7], 'GridAlpha', 0.4);
        xlim(ax1, [0 1]);
        ylim(ax1, [0 100]);
        
        ax2 = subplot(2, 2, 2, 'Parent', trainingFig);
        set(ax2, 'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'Box', 'on', 'LineWidth', 1.5);
        title(ax2, 'Loss', 'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.85 0.33 0.10]);
        xlabel(ax2, 'Iteration', 'FontSize', 11, 'Color', 'black');
        ylabel(ax2, 'Loss', 'FontSize', 11, 'Color', 'black');
        hold(ax2, 'on');
        grid(ax2, 'on');
        set(ax2, 'GridLineStyle', ':', 'GridColor', [0.7 0.7 0.7], 'GridAlpha', 0.4);
        xlim(ax2, [0 1]);
        ylim(ax2, [0 5]);
        
        ax3 = subplot(2, 2, 3, 'Parent', trainingFig);
        set(ax3, 'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'Box', 'on', 'LineWidth', 1.5);
        title(ax3, 'Training (smoothed)', 'FontSize', 14, 'FontWeight', 'bold', 'Color', [0.47 0.67 0.19]);
        xlabel(ax3, 'Iteration', 'FontSize', 11, 'Color', 'black');
        ylabel(ax3, 'Accuracy (%)', 'FontSize', 11, 'Color', 'black');
        hold(ax3, 'on');
        grid(ax3, 'on');
        set(ax3, 'GridLineStyle', ':', 'GridColor', [0.7 0.7 0.7], 'GridAlpha', 0.4);
        xlim(ax3, [0 1]);
        ylim(ax3, [0 100]);
        
        ax4 = subplot(2, 2, 4, 'Parent', trainingFig);
        set(ax4, 'Color', 'white');
        axis(ax4, 'off');
        
        % Info panel - determine hardware with error handling
        hwResource = 'CPU';  % Default
        try
            if gpuDeviceCount > 0
                try
                    gpuInfo = gpuDevice;
                    hwResource = sprintf('GPU: %s', gpuInfo.Name);
                catch
                    hwResource = 'GPU (Auto detect)';
                end
            end
        catch
            % GPU detection failed, use CPU
            hwResource = 'CPU';
        end
        
        infoText = uicontrol('Parent', trainingFig, 'Style', 'text', ...
                 'String', sprintf('Training Iteration 0 of 50\n\nTraining Time\nStart time: %s\nElapsed time: 00:00:00\n\nTraining Cycle\nEpoch: 0 of 50\nIterations per epoch: %d\nMaximum iterations: 50\n\nValidation\nFrequency: Every 3 iterations\n\nOther Information\nHardware resource: %s\nLearning rate schedule: Constant\nLearning rate: 0.0003', ...
                      datestr(now, 'dd-mmm-yyyy HH:MM:SS'), numel(imdsTrain.Files)/10, hwResource), ...
                 'Position', [500 20 580 280], ...
                 'BackgroundColor', [0.95 0.97 1.0], ...
                 'HorizontalAlignment', 'left', ...
                 'FontSize', 9, ...
                 'FontName', 'Consolas', ...
                 'FontWeight', 'normal', ...
                 'ForegroundColor', [0.2 0.2 0.2]);
        
        drawnow;
        
        % Store figure handles, info text, and hardware resource globally for the output function
        setappdata(0, 'TrainingAxes', struct('ax1', ax1, 'ax2', ax2, 'ax3', ax3, 'infoText', infoText, 'startTime', now, 'hwResource', hwResource));
        
        % Train
        trainedNet = trainNetwork(augimdsTrain, layers, options);
        
        set(statusText, 'String', 'Training completed successfully!');
        
        % Keep training figure open for review
        msgbox('Training completed! Check the training progress window.', 'Training Complete');
        
    catch ME
        errordlg(['Training failed: ' ME.message], 'Training Error');
        trainedNet = [];
        set(statusText, 'String', 'Training failed!');
        disp(ME.message);
    end
end

function stop = plotTrainingProgress(info, axAcc, axLoss, statusTxt)
    % Custom output function to plot training progress
    stop = false;
    
    persistent iteration accData lossData maxIter
    
    if info.State == "start"
        iteration = 0;
        accData = [];
        lossData = [];
        maxIter = 50;
        return;
    end
    
    if info.State == "iteration"
        iteration = iteration + 1;
        
        % Get training axes
        axStruct = getappdata(0, 'TrainingAxes');
        if isempty(axStruct)
            return;
        end
        
        ax1 = axStruct.ax1;
        ax2 = axStruct.ax2;
        ax3 = axStruct.ax3;
        infoText = axStruct.infoText;
        startTime = axStruct.startTime;
        hwResource = axStruct.hwResource;  % Get stored hardware resource
        
        % Collect data (convert to percentage if needed)
        if ~isempty(info.TrainingAccuracy)
            acc = info.TrainingAccuracy;
            % If accuracy is between 0 and 1, convert to percentage
            if acc <= 1
                acc = acc * 100;
            end
            accData(end+1) = acc;
        end
        if ~isempty(info.TrainingLoss)
            lossData(end+1) = info.TrainingLoss;
        end
        
        % Update axis limits dynamically
        if length(accData) > 1
            xlim(ax1, [0 max(length(accData)+5, maxIter)]);
            xlim(ax3, [0 max(length(accData)+5, maxIter)]);
        end
        if length(lossData) > 1
            xlim(ax2, [0 max(length(lossData)+5, maxIter)]);
            maxLoss = max(lossData) * 1.2;
            ylim(ax2, [0 max(maxLoss, 0.5)]);
        end
        
        % Clear axes and reset properties to prevent black background
        cla(ax1); cla(ax2); cla(ax3);
        set(ax1, 'Color', 'white', 'XColor', 'black', 'YColor', 'black');
        set(ax2, 'Color', 'white', 'XColor', 'black', 'YColor', 'black');
        set(ax3, 'Color', 'white', 'XColor', 'black', 'YColor', 'black');
        
        % Plot accuracy with smooth line
        if ~isempty(accData)
            plot(ax1, 1:length(accData), accData, '-', 'Color', [0.04 0.52 0.78], 'LineWidth', 3.0);
            hold(ax1, 'on');
            scatter(ax1, length(accData), accData(end), 90, [0.04 0.52 0.78], 'filled', 'MarkerEdgeColor', 'white', 'LineWidth', 2);
            grid(ax1, 'on');
            set(ax1, 'GridLineStyle', ':', 'GridColor', [0.7 0.7 0.7]);
            title(ax1, 'Accuracy', 'FontSize', 14, 'Color', [0.04 0.52 0.78]);
            xlabel(ax1, 'Iteration', 'Color', 'black');
            ylabel(ax1, 'Accuracy (%)', 'Color', 'black');
            hold(ax1, 'off');
            ylim(ax1, [0 100]);
        end
        
        % Plot loss with smooth line
        if ~isempty(lossData)
            plot(ax2, 1:length(lossData), lossData, '-', 'Color', [0.85 0.33 0.10], 'LineWidth', 3.0);
            hold(ax2, 'on');
            scatter(ax2, length(lossData), lossData(end), 90, [0.85 0.33 0.10], 'filled', 'MarkerEdgeColor', 'white', 'LineWidth', 2);
            grid(ax2, 'on');
            set(ax2, 'GridLineStyle', ':', 'GridColor', [0.7 0.7 0.7]);
            title(ax2, 'Loss', 'FontSize', 14, 'Color', [0.85 0.33 0.10]);
            xlabel(ax2, 'Iteration', 'Color', 'black');
            ylabel(ax2, 'Loss', 'Color', 'black');
            hold(ax2, 'off');
        end
        
        % Plot smoothed accuracy
        if length(accData) >= 3
            smoothAcc = smoothdata(accData, 'movmean', min(5, floor(length(accData)/2)));
            plot(ax3, 1:length(smoothAcc), smoothAcc, '-', 'Color', [0.47 0.67 0.19], 'LineWidth', 3.0);
            hold(ax3, 'on');
            scatter(ax3, length(smoothAcc), smoothAcc(end), 90, [0.47 0.67 0.19], 'filled', 'MarkerEdgeColor', 'white', 'LineWidth', 2);
            grid(ax3, 'on');
            set(ax3, 'GridLineStyle', ':', 'GridColor', [0.7 0.7 0.7]);
            title(ax3, 'Training (smoothed)', 'FontSize', 14, 'Color', [0.47 0.67 0.19]);
            xlabel(ax3, 'Iteration', 'Color', 'black');
            ylabel(ax3, 'Accuracy (%)', 'Color', 'black');
            hold(ax3, 'off');
            ylim(ax3, [0 100]);
        end
        
        % Calculate elapsed time
        elapsedSec = (now - startTime) * 86400;
        hours = floor(elapsedSec / 3600);
        mins = floor(mod(elapsedSec, 3600) / 60);
        secs = floor(mod(elapsedSec, 60));
        elapsedStr = sprintf('%02d:%02d:%02d', hours, mins, secs);
        
        % Update info panel
        if ~isempty(infoText) && isvalid(infoText)
            set(infoText, 'String', sprintf('Training Iteration %d of %d\n\nTraining Time\nStart time: %s\nElapsed time: %s\n\nTraining Cycle\nEpoch: %d of 50\nIterations per epoch: 1\nMaximum iterations: 50\n\nValidation\nFrequency: Every 3 iterations\n\nOther Information\nHardware resource: %s\nLearning rate schedule: Constant\nLearning rate: 0.0003', ...
                iteration, maxIter, datestr(startTime, 'dd-mmm-yyyy HH:MM:SS'), elapsedStr, info.Epoch, hwResource));
        end
        
        % Update status in main GUI
        if ~isempty(statusTxt) && isvalid(statusTxt)
            currentAcc = 0;
            if ~isempty(accData)
                currentAcc = accData(end);
            end
            set(statusTxt, 'String', sprintf('Training... Epoch: %d, Iteration: %d, Acc: %.2f%%', ...
                info.Epoch, iteration, currentAcc));
        end
        
        drawnow limitrate;
    end
end
