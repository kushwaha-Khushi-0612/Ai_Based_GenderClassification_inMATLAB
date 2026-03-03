function [confMat, accuracy, roc_data] = evaluateModel(trainedNet, testDataPath)
% Evaluate model performance on test dataset
% Inputs:
%   trainedNet - Trained classification network
%   testDataPath - Path to test dataset folder
% Outputs:
%   confMat - Confusion matrix
%   accuracy - Classification accuracy
%   roc_data - ROC curve data (TPR, FPR, AUC)

    try
        %% Load test dataset
        imdsTest = imageDatastore(testDataPath, ...
            'IncludeSubfolders', true, ...
            'LabelSource', 'foldernames');
        
        % Resize images to network input size
        inputSize = trainedNet.Layers(1).InputSize;
        augimdsTest = augmentedImageDatastore(inputSize(1:2), imdsTest);
        
        %% Classify test images
        [YPred, scores] = classify(trainedNet, augimdsTest);
        YTest = imdsTest.Labels;
        
        %% Calculate confusion matrix
        confMat = confusionmat(YTest, YPred);
        
        %% Calculate accuracy
        accuracy = sum(YPred == YTest) / numel(YTest);
        
        %% Calculate ROC data
        % For binary classification
        if numel(categories(YTest)) == 2
            % Get scores for positive class (Female)
            classes = categories(YTest);
            if ismember('female', classes)
                femaleIdx = find(strcmp(classes, 'female'));
            else
                femaleIdx = 1;
            end
            
            scoresPositive = scores(:, femaleIdx);
            
            % Create binary labels (1 for female, 0 for male)
            labelsTest = double(YTest == classes{femaleIdx});
            
            % Calculate ROC
            [fpr, tpr, ~, auc] = perfcurve(labelsTest, scoresPositive, 1);
            
            roc_data.FPR = fpr;
            roc_data.TPR = tpr;
            roc_data.AUC = auc;
        else
            roc_data = [];
        end
        
        %% Display results
        fprintf('\n=== Model Evaluation Results ===\n');
        fprintf('Accuracy: %.2f%%\n', accuracy * 100);
        fprintf('Confusion Matrix:\n');
        disp(confMat);
        
        if ~isempty(roc_data)
            fprintf('AUC: %.4f\n', roc_data.AUC);
        end
        
    catch ME
        warning('Evaluation failed: %s', ME.message);
        confMat = [];
        accuracy = 0;
        roc_data = [];
    end
end
