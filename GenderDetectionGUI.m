function GenderDetectionGUI
% AI-based Gender Identification using Facial Features
% Main GUI Application
% Author: AI Gender Detection System
% Date: March 2026

    % Create main figure
    fig = figure('Name', 'AI-based Gender Identification using Facial Features', ...
                 'NumberTitle', 'off', ...
                 'Position', [50 50 1400 700], ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'none', ...
                 'Resize', 'on', ...
                 'Color', [0.96 0.96 0.98]);
    
    % Title
    uicontrol('Style', 'text', ...
              'String', 'AI-based Gender Identification using Facial Features', ...
              'Position', [0 660 1400 40], ...
              'BackgroundColor', [0.1 0.4 0.8], ...
              'ForegroundColor', 'white', ...
              'FontSize', 16, ...
              'FontWeight', 'bold', ...
              'FontName', 'Arial');
    
    % Panel 1: Training Process
    panelTrain = uipanel('Title', 'Training Process', ...
                         'Position', [0.02 0.05 0.28 0.88], ...
                         'BackgroundColor', [0.95 0.97 1.0], ...
                         'FontSize', 12, ...
                         'FontWeight', 'bold', ...
                         'ForegroundColor', [0 0.3 0.6], ...
                         'BorderType', 'line', ...
                         'HighlightColor', [0.2 0.5 0.8]);
    
    % Panel 2: Testing Process  
    panelTest = uipanel('Title', 'Testing Process', ...
                        'Position', [0.31 0.05 0.34 0.88], ...
                        'BackgroundColor', [0.97 0.97 0.97], ...
                        'FontSize', 12, ...
                        'FontWeight', 'bold', ...
                        'ForegroundColor', [0 0.3 0.6], ...
                        'BorderType', 'line', ...
                        'HighlightColor', [0.2 0.5 0.8]);
    
    % Panel 3: Performance Analysis
    panelPerf = uipanel('Title', 'Performance Analysis', ...
                        'Position', [0.66 0.05 0.32 0.88], ...
                        'BackgroundColor', [0.95 1.0 0.97], ...
                        'FontSize', 12, ...
                        'FontWeight', 'bold', ...
                        'ForegroundColor', [0 0.3 0.6], ...
                        'BorderType', 'line', ...
                        'HighlightColor', [0.2 0.5 0.8]);
    
    %% Training Process Panel Components
    uicontrol('Parent', panelTrain, 'Style', 'text', ...
              'String', 'Sample Images of Train', ...
              'Position', [10 530 360 25], ...
              'BackgroundColor', [0.95 0.97 1.0], ...
              'FontSize', 11, ...
              'FontWeight', 'bold', ...
              'ForegroundColor', [0 0.3 0.6]);
    
    % Create axes for 9 sample training images (3x3 grid)
    trainAxes = cell(9, 1);
    row = 1;
    col = 1;
    for i = 1:9
        trainAxes{i} = axes('Parent', panelTrain, ...
                           'Units', 'pixels', ...
                           'Position', [20 + (col-1)*120, 180 + (3-row)*110, 100, 100]);
        set(trainAxes{i}, 'Color', 'white', 'XColor', 'white', 'YColor', 'white');
        axis(trainAxes{i}, 'off');
        col = col + 1;
        if col > 3
            col = 1;
            row = row + 1;
        end
    end
    
    % Training button
    btnTrainProcess = uicontrol('Parent', panelTrain, ...
                               'Style', 'radiobutton', ...
                               'String', 'Training Process', ...
                               'Position', [20 150 150 25], ...
                               'BackgroundColor', [0.95 0.97 1.0], ...
                               'FontSize', 10, ...
                               'FontWeight', 'bold', ...
                               'ForegroundColor', [0 0.3 0.6], ...
                               'Callback', @startTraining);
    
    % Load Network button
    btnLoadNetwork = uicontrol('Parent', panelTrain, ...
                              'Style', 'radiobutton', ...
                              'String', 'Load Network', ...
                              'Position', [20 120 150 25], ...
                              'BackgroundColor', [0.95 0.97 1.0], ...
                              'FontSize', 10, ...
                              'FontWeight', 'bold', ...
                              'ForegroundColor', [0 0.3 0.6], ...
                              'Callback', @loadNetwork);
    
    % Training progress text
    txtTrainStatus = uicontrol('Parent', panelTrain, ...
                              'Style', 'text', ...
                              'String', 'Ready to train...', ...
                              'Position', [20 80 340 30], ...
                              'BackgroundColor', [1 1 0.9], ...
                              'FontSize', 9, ...
                              'ForegroundColor', [0 0.5 0], ...
                              'HorizontalAlignment', 'center');
    
    %% Testing Process Panel Components
    % Test image axes
    axTestImg = axes('Parent', panelTest, 'Position', [0.05 0.55 0.25 0.40]);
    set(axTestImg, 'Color', 'white', 'XColor', 'white', 'YColor', 'white');
    title(axTestImg, 'Test Image', 'FontSize', 10, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    axis(axTestImg, 'off');
    
    % Face detection axes
    axFaceDetect = axes('Parent', panelTest, 'Position', [0.37 0.55 0.25 0.40]);
    set(axFaceDetect, 'Color', 'white', 'XColor', 'white', 'YColor', 'white');
    title(axFaceDetect, 'Face Detection', 'FontSize', 10, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    axis(axFaceDetect, 'off');
    
    % ROI extraction axes
    axROI = axes('Parent', panelTest, 'Position', [0.69 0.55 0.25 0.40]);
    set(axROI, 'Color', 'white', 'XColor', 'white', 'YColor', 'white');
    title(axROI, 'ROI Region Extraction', 'FontSize', 10, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    axis(axROI, 'off');
    
    % Preprocessed result axes
    axPreprocess = axes('Parent', panelTest, 'Position', [0.05 0.08 0.25 0.38]);
    set(axPreprocess, 'Color', 'white', 'XColor', 'white', 'YColor', 'white');
    title(axPreprocess, 'Preprocessed Result', 'FontSize', 10, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    axis(axPreprocess, 'off');
    
    % Gender classification result axes
    axClassResult = axes('Parent', panelTest, 'Position', [0.37 0.08 0.25 0.38]);
    set(axClassResult, 'Color', 'white', 'XColor', 'white', 'YColor', 'white');
    title(axClassResult, 'Classification Result (AlexNet-CNN)', ...
          'FontSize', 10, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    axis(axClassResult, 'off');
    
    % Testing button
    btnTestProcess = uicontrol('Parent', panelTest, ...
                              'Style', 'radiobutton', ...
                              'String', 'Testing Process', ...
                              'Position', [350 520 120 25], ...
                              'BackgroundColor', 'white', ...
                              'FontSize', 10, ...
                              'Callback', @startTesting);
    
    % Browse test image button
    btnBrowseTest = uicontrol('Parent', panelTest, ...
                             'Style', 'pushbutton', ...
                             'String', 'Browse Test Image', ...
                             'Position', [350 490 120 25], ...
                             'FontSize', 9, ...
                             'Callback', @browseTestImage);
    
    %% Performance Analysis Panel Components
    % Confusion Matrix axes
    axConfusion = axes('Parent', panelPerf, 'Position', [0.1 0.55 0.35 0.35]);
    set(axConfusion, 'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'Box', 'on');
    title(axConfusion, 'Confusion Matrix', 'FontSize', 9, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    text(axConfusion, 0.5, 0.5, 'Run Performance Analysis', ...
         'HorizontalAlignment', 'center', 'FontSize', 9, 'Color', [0.5 0.5 0.5]);
    axis(axConfusion, [0 1 0 1]);
    
    % ROC Curve axes
    axROC = axes('Parent', panelPerf, 'Position', [0.55 0.55 0.35 0.35]);
    set(axROC, 'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'Box', 'on');
    title(axROC, 'ROC Curve', 'FontSize', 9, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    text(axROC, 0.5, 0.5, 'Run Performance Analysis', ...
         'HorizontalAlignment', 'center', 'FontSize', 9, 'Color', [0.5 0.5 0.5]);
    axis(axROC, [0 1 0 1]);
    
    % Accuracy plot axes
    axAccuracy = axes('Parent', panelPerf, 'Position', [0.1 0.05 0.35 0.35]);
    set(axAccuracy, 'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'Box', 'on');
    title(axAccuracy, 'Training Accuracy', 'FontSize', 9, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    text(axAccuracy, 0.5, 0.5, 'Start Training', ...
         'HorizontalAlignment', 'center', 'FontSize', 9, 'Color', [0.5 0.5 0.5]);
    axis(axAccuracy, [0 1 0 1]);
    
    % Loss plot axes
    axLoss = axes('Parent', panelPerf, 'Position', [0.55 0.05 0.35 0.35]);
    set(axLoss, 'Color', 'white', 'XColor', 'black', 'YColor', 'black', 'Box', 'on');
    title(axLoss, 'Training Loss', 'FontSize', 9, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
    text(axLoss, 0.5, 0.5, 'Start Training', ...
         'HorizontalAlignment', 'center', 'FontSize', 9, 'Color', [0.5 0.5 0.5]);
    axis(axLoss, [0 1 0 1]);
    
    % Results text box (placed at top of panel)
    uicontrol('Parent', panelPerf, 'Style', 'text', ...
              'String', 'AlexNet CNN based Gender Classification', ...
              'Position', [20 560 400 25], ...
              'BackgroundColor', [0.95 1.0 0.97], ...
              'FontSize', 11, ...
              'FontWeight', 'bold');
    
    txtGenderResult = uicontrol('Parent', panelPerf, 'Style', 'edit', ...
                               'String', '', ...
                               'Position', [80 525 280 30], ...
                               'FontSize', 12, ...
                               'HorizontalAlignment', 'center', ...
                               'Enable', 'inactive');
    
    uicontrol('Parent', panelPerf, 'Style', 'text', ...
              'String', 'Predicted Score', ...
              'Position', [80 500 280 20], ...
              'BackgroundColor', [0.95 1.0 0.97], ...
              'FontSize', 10, ...
              'FontWeight', 'bold');
    
    txtPredScore = uicontrol('Parent', panelPerf, 'Style', 'edit', ...
                            'String', '', ...
                            'Position', [80 470 280 30], ...
                            'FontSize', 12, ...
                            'HorizontalAlignment', 'center', ...
                            'Enable', 'inactive');
    
    % Performance Analysis button
    btnPerfAnalysis = uicontrol('Parent', panelPerf, ...
                               'Style', 'radiobutton', ...
                               'String', 'Performance Analysis', ...
                               'Position', [110 430 200 25], ...
                               'BackgroundColor', [0.95 1.0 0.97], ...
                               'FontSize', 10, ...
                               'Callback', @performanceAnalysis);
    
    %% Global Variables
    trainedNet = [];
    testImage = [];
    datasetPath = fullfile(pwd, 'dataset');
    modelPath = fullfile(pwd, 'trained_model.mat');
    
    %% Callback Functions
    
    function startTraining(~, ~)
        % Start training process
        set(txtTrainStatus, 'String', 'Starting training process...');
        drawnow;
        
        % Display sample training images
        displaySampleImages();
        
        % Train the network
        trainedNet = trainGenderClassifier(datasetPath, trainAxes, txtTrainStatus, axAccuracy, axLoss);
        
        if ~isempty(trainedNet)
            % Save the trained model
            save(modelPath, 'trainedNet');
            set(txtTrainStatus, 'String', 'Training complete! Model saved.');
            msgbox('Training completed successfully! Model saved.', 'Success');
        end
    end
    
    function loadNetwork(~, ~)
        % Load pre-trained network
        if exist(modelPath, 'file')
            load(modelPath, 'trainedNet');
            set(txtTrainStatus, 'String', 'Trained network loaded successfully!');
            displaySampleImages();
            msgbox('Trained network loaded successfully!', 'Network Loaded');
        else
            errordlg('No trained model found! Please train the network first.', 'Model Not Found');
            set(txtTrainStatus, 'String', 'No trained model found!');
        end
    end
    
    function displaySampleImages()
        % Display random sample images from training dataset
        femaleDir = fullfile(datasetPath, 'female');
        maleDir = fullfile(datasetPath, 'male');
        
        femaleFiles = dir(fullfile(femaleDir, '*.jpg'));
        maleFiles = dir(fullfile(maleDir, '*.jpg'));
        
        if isempty(femaleFiles) || isempty(maleFiles)
            set(txtTrainStatus, 'String', 'Error: Dataset not found in dataset/ folder');
            return;
        end
        
        % Randomly select 4-5 images from each class
        numFemale = min(4, length(femaleFiles));
        numMale = min(5, length(maleFiles));
        
        femaleIdx = randperm(length(femaleFiles), numFemale);
        maleIdx = randperm(length(maleFiles), numMale);
        
        imgCounter = 1;
        
        % Display female images
        for i = 1:numFemale
            if imgCounter <= 9
                img = imread(fullfile(femaleDir, femaleFiles(femaleIdx(i)).name));
                img = imresize(img, [100 100]);
                imshow(img, 'Parent', trainAxes{imgCounter});
                imgCounter = imgCounter + 1;
            end
        end
        
        % Display male images
        for i = 1:numMale
            if imgCounter <= 9
                img = imread(fullfile(maleDir, maleFiles(maleIdx(i)).name));
                img = imresize(img, [100 100]);
                imshow(img, 'Parent', trainAxes{imgCounter});
                imgCounter = imgCounter + 1;
            end
        end
    end
    
    function browseTestImage(~, ~)
        % Browse and select test image
        [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files'}, ...
                                         'Select Test Image');
        if filename ~= 0
            testImage = imread(fullfile(pathname, filename));
            imshow(testImage, 'Parent', axTestImg);
            title(axTestImg, 'Test Image', 'FontSize', 10, 'FontWeight', 'bold');
        end
    end
    
    function startTesting(~, ~)
        % Start testing process
        if isempty(testImage)
            errordlg('Please browse and select a test image first!', 'No Test Image');
            return;
        end
        
        if isempty(trainedNet)
            errordlg('Please train or load the network first!', 'No Model');
            return;
        end
        
        % Perform gender classification
        [gender, score, faceImg, roiImg, processedImg] = classifyGender(testImage, trainedNet);
        
        % Display results
        if ~isempty(faceImg)
            imshow(faceImg, 'Parent', axFaceDetect);
            title(axFaceDetect, 'Face Detection', 'FontSize', 10, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
            
            imshow(roiImg, 'Parent', axROI);
            title(axROI, 'ROI Region Extraction', 'FontSize', 10, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
            
            imshow(processedImg, 'Parent', axPreprocess);
            title(axPreprocess, 'Preprocessed Result', 'FontSize', 10, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
            
            % Show classification result
            try
                resultImg = insertText(faceImg, [10 10], gender, 'FontSize', 30, ...
                                      'TextColor', 'red', 'BoxOpacity', 0);
            catch
                % Fallback if Computer Vision Toolbox not available
                resultImg = faceImg;
            end
            imshow(resultImg, 'Parent', axClassResult);
            title(axClassResult, 'Classification Result (AlexNet-CNN)', ...
                  'FontSize', 10, 'FontWeight', 'bold', 'Color', [0 0.3 0.6]);
            
            % Update result text
            set(txtGenderResult, 'String', gender);
            set(txtPredScore, 'String', sprintf('%.4f', score));
        else
            errordlg('No face detected in the image!', 'Face Detection Failed');
        end
    end
    
    function performanceAnalysis(~, ~)
        % Perform performance analysis on test set
        if isempty(trainedNet)
            errordlg('Please train or load the network first!', 'No Model');
            return;
        end
        
        testDataPath = fullfile(pwd, 'test');
        if ~exist(testDataPath, 'dir')
            errordlg('Test dataset not found! Please create test/ folder with male/ and female/ subfolders.', ...
                    'Dataset Error');
            return;
        end
        
        % Evaluate model performance
        [confMat, accuracy, roc_data] = evaluateModel(trainedNet, testDataPath);
        
        % Clear axes and reset properties
        cla(axConfusion); cla(axROC); cla(axAccuracy);
        set(axConfusion, 'Color', 'white', 'XColor', 'black', 'YColor', 'black');
        set(axROC, 'Color', 'white', 'XColor', 'black', 'YColor', 'black');
        set(axAccuracy, 'Color', 'white', 'XColor', 'black', 'YColor', 'black');
        
        % Plot confusion matrix
        plotConfusionMatrix(confMat, axConfusion);
        
        % Plot ROC curve
        if ~isempty(roc_data)
            plotROCCurve(roc_data, axROC);
        end
        
        % Display accuracy
        displayAccuracyMetrics(accuracy, axAccuracy);
        
        msgbox(sprintf('Model Accuracy: %.2f%%', accuracy*100), 'Performance Analysis');
    end

end
