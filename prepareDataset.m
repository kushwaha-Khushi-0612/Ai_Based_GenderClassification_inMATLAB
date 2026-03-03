function prepareDataset()
% Prepare dataset for MATLAB training
% This function organizes images from the dataset folders into proper structure

    fprintf('=== Dataset Preparation Tool ===\n\n');
    
    %% Define paths
    projectRoot = pwd;
    
    % Source paths (from AI_Gender_Detection_System)
    sourceDataset = fullfile(projectRoot, 'AI_Gender_Detection_System', 'objectives');
    sourceTest = fullfile(projectRoot, 'AI_Gender_Detection_System', 'test');
    
    % Also check root-level dataset and test folders
    rootDataset = fullfile(projectRoot, 'dataset');
    rootTest = fullfile(projectRoot, 'test');
    
    % Target paths (for MATLAB)
    targetDataset = fullfile(projectRoot, 'dataset');
    targetTest = fullfile(projectRoot, 'test');
    
    %% Check which source to use
    if exist(rootDataset, 'dir') && ~isempty(dir(fullfile(rootDataset, 'male', '*.jpg')))
        fprintf('Using existing root-level dataset folder...\n');
        datasetReady = true;
    elseif exist(sourceDataset, 'dir')
        fprintf('Copying from AI_Gender_Detection_System/objectives...\n');
        
        % Create target directories
        mkdir(fullfile(targetDataset, 'male'));
        mkdir(fullfile(targetDataset, 'female'));
        
        % Copy male images
        if exist(fullfile(sourceDataset, 'male'), 'dir')
            copyfile(fullfile(sourceDataset, 'male', '*.jpg'), ...
                    fullfile(targetDataset, 'male'));
        end
        
        % Copy female images
        if exist(fullfile(sourceDataset, 'female'), 'dir')
            copyfile(fullfile(sourceDataset, 'female', '*.jpg'), ...
                    fullfile(targetDataset, 'female'));
        end
        
        datasetReady = true;
    else
        fprintf('Warning: No dataset found!\n');
        datasetReady = false;
    end
    
    %% Prepare test dataset
    if exist(rootTest, 'dir') && ~isempty(dir(fullfile(rootTest, 'male', '*.jpg')))
        fprintf('Using existing root-level test folder...\n');
        testReady = true;
    elseif exist(sourceTest, 'dir')
        fprintf('Copying from AI_Gender_Detection_System/test...\n');
        
        % Create target directories
        mkdir(fullfile(targetTest, 'male'));
        mkdir(fullfile(targetTest, 'female'));
        
        % Copy male test images
        if exist(fullfile(sourceTest, 'male'), 'dir')
            copyfile(fullfile(sourceTest, 'male', '*.jpg'), ...
                    fullfile(targetTest, 'male'));
        end
        
        % Copy female test images
        if exist(fullfile(sourceTest, 'female'), 'dir')
            copyfile(fullfile(sourceTest, 'female', '*.jpg'), ...
                    fullfile(targetTest, 'female'));
        end
        
        testReady = true;
    else
        fprintf('Warning: No test dataset found!\n');
        testReady = false;
    end
    
    %% Display statistics
    fprintf('\n=== Dataset Statistics ===\n');
    
    if datasetReady
        maleFiles = dir(fullfile(targetDataset, 'male', '*.jpg'));
        femaleFiles = dir(fullfile(targetDataset, 'female', '*.jpg'));
        
        fprintf('Training Dataset:\n');
        fprintf('  Male faces: %d\n', length(maleFiles));
        fprintf('  Female faces: %d\n', length(femaleFiles));
        fprintf('  Total: %d\n', length(maleFiles) + length(femaleFiles));
    else
        fprintf('Training dataset not found!\n');
    end
    
    fprintf('\n');
    
    if testReady
        maleTestFiles = dir(fullfile(targetTest, 'male', '*.jpg'));
        femaleTestFiles = dir(fullfile(targetTest, 'female', '*.jpg'));
        
        fprintf('Test Dataset:\n');
        fprintf('  Male faces: %d\n', length(maleTestFiles));
        fprintf('  Female faces: %d\n', length(femaleTestFiles));
        fprintf('  Total: %d\n', length(maleTestFiles) + length(femaleTestFiles));
    else
        fprintf('Test dataset not found!\n');
    end
    
    fprintf('\n=== Dataset Preparation Complete ===\n');
    
    if datasetReady
        fprintf('You can now run: GenderDetectionGUI\n');
    else
        fprintf('\nPlease ensure you have:\n');
        fprintf('  1. dataset/male/ folder with male face images\n');
        fprintf('  2. dataset/female/ folder with female face images\n');
        fprintf('  3. test/male/ folder with test male images\n');
        fprintf('  4. test/female/ folder with test female images\n');
    end
end
