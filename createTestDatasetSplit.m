function createTestDatasetSplit()
% Create test dataset by splitting images from main dataset
% This creates a test set if one doesn't exist

    fprintf('=== Creating Test Dataset Split ===\n\n');
    
    %% Define paths
    datasetPath = fullfile(pwd, 'dataset');
    testPath = fullfile(pwd, 'test');
    
    %% Check if dataset exists
    if ~exist(datasetPath, 'dir')
        fprintf('Error: Dataset folder not found!\n');
        return;
    end
    
    %% Create test directories
    mkdir(fullfile(testPath, 'male'));
    mkdir(fullfile(testPath, 'female'));
    
    %% Process male images
    maleSource = fullfile(datasetPath, 'male');
    maleTest = fullfile(testPath, 'male');
    
    if exist(maleSource, 'dir')
        maleFiles = dir(fullfile(maleSource, '*.jpg'));
        
        % Take 20% for test
        numTest = max(1, round(0.2 * length(maleFiles)));
        
        % Randomly select test images
        testIdx = randperm(length(maleFiles), numTest);
        
        fprintf('Copying %d male images to test set...\n', numTest);
        for i = 1:numTest
            sourceFile = fullfile(maleSource, maleFiles(testIdx(i)).name);
            targetFile = fullfile(maleTest, maleFiles(testIdx(i)).name);
            
            % Copy instead of move to preserve original dataset
            copyfile(sourceFile, targetFile);
        end
    end
    
    %% Process female images
    femaleSource = fullfile(datasetPath, 'female');
    femaleTest = fullfile(testPath, 'female');
    
    if exist(femaleSource, 'dir')
        femaleFiles = dir(fullfile(femaleSource, '*.jpg'));
        
        % Take 20% for test
        numTest = max(1, round(0.2 * length(femaleFiles)));
        
        % Randomly select test images
        testIdx = randperm(length(femaleFiles), numTest);
        
        fprintf('Copying %d female images to test set...\n', numTest);
        for i = 1:numTest
            sourceFile = fullfile(femaleSource, femaleFiles(testIdx(i)).name);
            targetFile = fullfile(femaleTest, femaleFiles(testIdx(i)).name);
            
            % Copy instead of move to preserve original dataset
            copyfile(sourceFile, targetFile);
        end
    end
    
    %% Display results
    fprintf('\n=== Test Dataset Created ===\n');
    
    maleTestFiles = dir(fullfile(maleTest, '*.jpg'));
    femaleTestFiles = dir(fullfile(femaleTest, '*.jpg'));
    
    fprintf('Test set:\n');
    fprintf('  Male: %d images\n', length(maleTestFiles));
    fprintf('  Female: %d images\n', length(femaleTestFiles));
    fprintf('  Total: %d images\n', length(maleTestFiles) + length(femaleTestFiles));
    
    fprintf('\nTest dataset ready for performance evaluation!\n');
end
